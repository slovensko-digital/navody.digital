module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class ApplicationForm
        include ActiveModel::Model

        attr_accessor(:cin, :corporate_body, :form_data, :company_municipality,
                      :stakeholder, :stakeholder_nationality, :stakeholder_identifier, :stakeholder_other_identifier, :stakeholder_identifier_type,
                      :stakeholder_dob, :stakeholder_dob_year, :stakeholder_dob_month, :stakeholder_dob_day, :stakeholder_municipality,
                      :current_stakeholder_index, :current_step, :go_to_summary, :back)

        validate :corporate_body_selected?
        validate :identifier_valid?
        validate :stakeholder_municipality_set?
        validate :company_municipality_set?

        def initialize(cin: nil, json_form_data: nil, form_data: nil, company_municipality: nil,
                       stakeholder_nationality: nil, stakeholder_identifier: nil, stakeholder_other_identifier: nil, stakeholder_other_identifier_type: nil,
                       stakeholder_dob_year: nil, stakeholder_dob_month: nil, stakeholder_dob_day: nil, current_stakeholder_index: -1, stakeholder_municipality: nil,
                       current_step: nil, go_to_summary: false, back: false)
          @cin = cin
          @company_municipality = company_municipality
          if json_form_data
            form_data = JSON.parse(json_form_data)
            @form_data = UpvsSubmissions::Forms::FuzsData.new(
              cin: form_data['cin'],
              name: form_data['name'],
              address: form_data['address'],
              court: form_data['court'],
              type: form_data['org_type'],
              registration_number: form_data['registration_number'],
              stakeholders: form_data['stakeholders']
            )
          else
            @form_data = form_data
          end

          @stakeholder_nationality = stakeholder_nationality
          @stakeholder_identifier = stakeholder_identifier
          @stakeholder_other_identifier = stakeholder_other_identifier
          @stakeholder_other_identifier_type = stakeholder_other_identifier_type
          @stakeholder_dob_year = stakeholder_dob_year
          @stakeholder_dob_month = stakeholder_dob_month
          @stakeholder_dob_day = stakeholder_dob_day
          @stakeholder_municipality = stakeholder_municipality
          @current_stakeholder_index = current_stakeholder_index
          @current_step = current_step
          @go_to_summary = go_to_summary
          @back = back
        end

        def should_go_to_company_address?
          @form_data.with_missing_municipality_identifier? && (@current_step == 'subject_selection' || (go_back? && showing_first_stakeholder?))
        end

        def should_go_to_summary?
          showing_last_stakeholder? || (@current_step == 'save' && go_to_summary?)
        end

        def go_to_summary?
          @go_to_summary == 'true'
        end

        def go_back?
          back == 'true'
        end

        def showing_first_stakeholder?
          @current_stakeholder_index == 0
        end

        def showing_last_stakeholder?
          @current_stakeholder_index == @form_data&.stakeholders_with_missing_identifiers&.size - 1
        end

        def company_address_valid?
          valid?(:company_municipality)
        end

        def corporate_body_invalid?
          should_validate_cb? && !valid?(:corporate_body)
        end

        def identifiers_valid?
          valid?(:identifier) && valid?(:other_identifier)
        end

        private

        SR_CB_IDENTIFIER_PATTERN = /\A\d{6,8}\z/
        SR_PERSON_IDENTIFIER_PATTERN = /\A(\d{2})(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])\/?\d{3,4}\z/

        def should_validate_cb?
          @current_step == 'subject_selection'
        end

        def corporate_body_selected?
          errors.add(:corporate_body, 'Zvoľte spoločnosť') unless @cin.present?
        end

        def company_municipality_set?
          if !@company_municipality.present? && @current_step == 'company_address'
            errors.add(:company_municipality, 'Zvoľte obec')
          end
        end

        def stakeholder_municipality_set?
          if !@stakeholder_municipality.present? && @current_step == 'save'
            errors.add(:stakeholder_municipality, 'Zvoľte obec')
          end
        end

        def identifier_valid?
          if @stakeholder_nationality == 'sr'
            sr_stakeholder_identifier_valid?
          elsif @stakeholder_nationality == 'foreign'
             foreign_stakeholder_identifier_valid?
          end
        end

        def sr_stakeholder_identifier_valid?
          if @stakeholder_identifier.present?
            @stakeholder.is_person? ? sr_person_identifier_valid? : sr_cb_identifier_valid?
          else
            errors.add(:stakeholder_identifier, missing_identifier_message)
          end
        end

        def foreign_stakeholder_identifier_valid?
          errors.add(:stakeholder_other_identifier_type, 'Zvoľte typ identifikačného údaju') if @stakeholder&.is_person? && !@stakeholder_other_identifier_type.present?

          if !@stakeholder_other_identifier.present?
            errors.add(:stakeholder_other_identifier, 'Vyplňte identifikačný údaj')
          else
            errors.add(:stakeholder_other_identifier, 'Identifikačný údaj môže obsahovať maximálne 20 znakov') if @stakeholder_other_identifier.length > 20
          end

          dob_valid? if @stakeholder&.is_person?
        end

        def sr_cb_identifier_valid?
          errors.add(:stakeholder_identifier, 'IČO má obsahovať 6 až 8 číslic') unless @stakeholder_identifier.match(SR_CB_IDENTIFIER_PATTERN)
        end

        def sr_person_identifier_valid?
          errors.add(:stakeholder_identifier, 'Rodné číslo môže obsahovať len číslice a lomku vo formáte 000000/0000') unless @stakeholder_identifier.match(SR_PERSON_IDENTIFIER_PATTERN)
        end

        def dob_valid?
          if dob_missing?
            errors.add(:stakeholder_dob, 'Vyplňte dátum narodenia')
          elsif invalid_dob?
            errors.add(:stakeholder_dob, 'Zvoľte validný dátum narodenia')
            invalid_date_errors
          elsif @stakeholder_dob_year.length < 4
            errors.add(:stakeholder_dob, 'Zadajte celý rok narodenia, napr. 1983')
            invalid_date_errors(day_condition: true, month_condition: true, year_condition: false)
          elsif @stakeholder_dob_year.to_i < 1900
            errors.add(:stakeholder_dob, 'Rok narodenia nemôže byť starší ako 1900')
            invalid_date_errors(day_condition: true, month_condition: true, year_condition: false)
          end
        end

        def dob_missing?
          invalid_date_errors(day_condition: @stakeholder_dob_day.present?, month_condition: @stakeholder_dob_month.present?, year_condition: @stakeholder_dob_year.present?)

          !@stakeholder_dob_year.present? || !@stakeholder_dob_month.present? || !@stakeholder_dob_day.present?
        end

        def missing_identifier_message
          @stakeholder.is_person?  ? 'Vyplňte rodné číslo' : 'Vyplňte IČO'
        end

        def invalid_date_errors(day_condition: false, month_condition: false, year_condition: false)
          errors.add(:stakeholder_dob_day, nil) unless day_condition
          errors.add(:stakeholder_dob_month, nil) unless month_condition
          errors.add(:stakeholder_dob_year, nil) unless year_condition
        end

        def invalid_dob?
          !Date.valid_date?(@stakeholder_dob_year.to_i, @stakeholder_dob_month.to_i, @stakeholder_dob_day.to_i) || Date.new(@stakeholder_dob_year.to_i, @stakeholder_dob_month.to_i, @stakeholder_dob_day.to_i).future?
        end
      end
    end
  end
end
