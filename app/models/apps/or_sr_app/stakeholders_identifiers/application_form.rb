module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class ApplicationForm
        include ActiveModel::Model

        attr_accessor :form_data
        attr_accessor :stakeholder
        attr_accessor :stakeholder_identifier
        attr_accessor :stakeholder_nationality
        attr_accessor :stakeholder_other_identifier
        attr_accessor :stakeholder_identifier_type
        attr_accessor :stakeholder_dob_year
        attr_accessor :stakeholder_dob_month
        attr_accessor :stakeholder_dob_day
        attr_accessor :current_stakeholder_index
        attr_accessor :correct_data
        attr_accessor :current_step
        attr_accessor :go_to_summary
        attr_accessor :back

        validates_presence_of :stakeholder_identifier, message: 'Vyplňte rodné číslo', on: :place

        def initialize(json_form_data: nil, form_data: nil, current_stakeholder_index: -1, correct_data: false, current_step: 'save', go_to_summary: false, back: false)
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

          @current_stakeholder_index = current_stakeholder_index
          @correct_data = correct_data
          @current_step = current_step
          @go_to_summary = go_to_summary
          @back = back
        end

        def should_go_to_summary?
          (@current_step == 'save' && @go_to_summary == 'true') || (@current_stakeholder_index == @form_data&.stakeholders_with_missing_identifiers&.size - 1)
        end

        def go_back?
          back == 'true'
        end
      end
    end
  end
end
