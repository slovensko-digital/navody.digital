module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class ApplicationForm
        include ActiveModel::Model

        attr_accessor :cin
        attr_accessor :subject_search
        attr_accessor :form_data
        attr_accessor :stakeholder
        attr_accessor :stakeholder_nationality
        attr_accessor :stakeholder_identifier
        attr_accessor :stakeholder_other_identifier
        attr_accessor :stakeholder_identifier_type
        attr_accessor :stakeholder_dob
        attr_accessor :stakeholder_dob_year
        attr_accessor :stakeholder_dob_month
        attr_accessor :stakeholder_dob_day
        attr_accessor :current_stakeholder_index
        attr_accessor :current_step
        attr_accessor :go_to_summary
        attr_accessor :back

        validate :corporate_body_selected?
        validate :identifier_valid?

        def initialize(cin: nil, json_form_data: nil, form_data: nil,
                       stakeholder_nationality: nil, stakeholder_identifier: nil, stakeholder_other_identifier: nil, stakeholder_other_identifier_type: nil,
                       stakeholder_dob_year: nil, stakeholder_dob_month: nil, stakeholder_dob_day: nil, current_stakeholder_index: -1,
                       current_step: nil, go_to_summary: false, back: false)
          @cin = cin
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
          @current_stakeholder_index = current_stakeholder_index
          @current_step = current_step
          @go_to_summary = go_to_summary
          @back = back
        end

        def should_go_to_summary?
          (@current_step == 'save' && go_to_summary?) || (@current_stakeholder_index == @form_data&.stakeholders_with_missing_identifiers&.size - 1)
        end

        def go_to_summary?
          @go_to_summary == 'true'
        end

        def go_back?
          back == 'true'
        end

        def cin_invalid?
          should_validate_cin? && !valid?(:cin)
        end

        def identifiers_valid?
          valid?(:identifier) && valid?(:other_identifier)
        end

        private

        SR_PERSON_IDENTIFIER_PATTERN = /(\d{2})(0[1-9]|1[0-2]|5[1-9]|6[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])\/?\d{3,4}/

        def should_validate_cin?
          @current_step == 'subject_selection'
        end

        def corporate_body_selected?
          errors.add(:corporate_body, 'Zvoľte spoločnosť') unless @cin.present?
        end

        def identifier_valid?
          if @stakeholder_nationality == 'sr'
            sr_stakeholder_identifier_valid?
          elsif @stakeholder_nationality == 'foreign'
             foreign_stakeholder_identifier_valid?
          end
        end

        def sr_stakeholder_identifier_valid?
          @stakeholder_identifier.present? ? sr_person_identifier_valid? : errors.add(:stakeholder_identifier, missing_identifier_message)
        end

        def foreign_stakeholder_identifier_valid?
          errors.add(:stakeholder_other_identifier_type, 'Zvoľte typ identifikačného údaju') if @stakeholder&.is_person? && !@stakeholder_other_identifier_type.present?
          errors.add(:stakeholder_other_identifier, 'Vyplňte identifikačný údaj') unless @stakeholder_other_identifier.present?

          dob_valid? if @stakeholder&.is_person?
        end

        def sr_person_identifier_valid?
          errors.add(:stakeholder_identifier, 'Zadajte validné rodné číslo bez /') unless @stakeholder_identifier.match(SR_PERSON_IDENTIFIER_PATTERN)
        end

        def dob_valid?
          if dob_missing?
            errors.add(:stakeholder_dob, 'Vyplňte dátum narodenia')
          elsif !Date.valid_date?(@stakeholder_dob_year.to_i, @stakeholder_dob_month.to_i, @stakeholder_dob_day.to_i)
            errors.add(:stakeholder_dob, 'Zvoľte validný dátum narodenia')
            invalid_date_errors(day_condition: false, month_condition: false, year_condition: false)
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
      end
    end
  end
end
