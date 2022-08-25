module Apps
  module OrSrApp
    module StakeholdersIdentifiers
      class ApplicationForm
        include ActiveModel::Model

        attr_accessor :form_data
        attr_accessor :stakeholder
        attr_accessor :stakeholder_identifier
        attr_accessor :current_stakeholder_index
        attr_accessor :back

        validates_presence_of :stakeholder_identifier, message: 'Vyplňte rodné číslo', on: :place

        def initialize(json_form_data: nil, form_data: nil, current_stakeholder_index: -1, back: false)
          if json_form_data
            form_data = JSON.parse(json_form_data)
            @form_data = UpvsSubmissions::Forms::Fuzs.new(
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
          @back = back
        end

        def go_back?
          back == "true"
        end
      end
    end
  end
end
