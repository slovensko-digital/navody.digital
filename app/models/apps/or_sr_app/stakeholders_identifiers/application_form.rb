module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class ApplicationForm
        include ActiveModel::Model

        attr_accessor :cin
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
        attr_accessor :correct_data
        attr_accessor :current_step
        attr_accessor :go_to_summary
        attr_accessor :back

        validates_presence_of :cin, message: 'Zvoľte spoločnosť'
        validate :identifier_valid?

        def initialize(cin: nil, json_form_data: nil, form_data: nil,
                       stakeholder_nationality: nil, stakeholder_identifier: nil, stakeholder_other_identifier: nil, stakeholder_other_identifier_type: nil,
                       stakeholder_dob_year: nil, stakeholder_dob_month: nil, stakeholder_dob_day: nil, current_stakeholder_index: -1,
                       correct_data: false, current_step: nil, go_to_summary: false, back: false)
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
          @correct_data = correct_data
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

        def should_validate_cin?
          @current_step == 'subject_selection'
        end

        private

        def identifier_valid?
          if @stakeholder_nationality == 'sr' && !@stakeholder_identifier.present?
            errors.add(:stakeholder_identifier, missing_identifier_message)
          elsif @stakeholder_nationality == 'foreign'
            unless @stakeholder_other_identifier.present?
              errors.add(:stakeholder_other_identifier_type, 'Zvoľte typ identifikačného údaju') if @stakeholder.is_person?
              errors.add(:stakeholder_other_identifier, 'Vyplňte identifikačný údaj')
            end

            errors.add(:stakeholder_dob, 'Vyplňte dátum narodenia') if dob_missing? && @stakeholder.is_person?
          end
        end

        def dob_missing?
          errors.add(:stakeholder_dob_day, '') unless @stakeholder_dob_day.present?
          errors.add(:stakeholder_dob_month, '') unless @stakeholder_dob_month.present?
          errors.add(:stakeholder_dob_year, '') unless @stakeholder_dob_year.present?

          !@stakeholder_dob_year.present? || !@stakeholder_dob_month.present? || !@stakeholder_dob_day.present?
        end

        def missing_identifier_message
          @stakeholder.is_person?  ? 'Vyplňte rodné číslo' : 'Vyplňte IČO'
        end
      end
    end
  end
end
