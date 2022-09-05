module Apps
  module OrSrApp
    module ActsSubmission
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :corporate_body_selected?
        # validates_presence_of :email, :presence => true, message: 'Zadajte emailovú adresu'
        # validates :email, if: -> { email.present? },
        #           format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }
        # validates :acts, :presence => true, message: 'Vyberte aspoň jednu listinu'

        attr_accessor(
          :email,
          :acts,
          :corporate_body,
          :business_cin,
          :business_name,
          :business_address,
          :business_section,
          :business_insertion,
          :business_court,
          :current_step,
          :back
        )

        def acts=(array)
          @acts = array.map do |act|
            Act.new(act)
          end
        end

        def encoded_note
          Base64.encode64(note.to_s)
        end

        def cb_invalid?
          should_validate_corporate_body? && !valid?(:corporate_body)
        end

        private

        def note
          {
            value: business_cin,
            text: business_name,
            title: business_address,
            descr: {
              oddiel: business_section.to_i,
              vlozka: business_insertion.to_i,
              sud: business_court.to_i
            }.to_json.to_s,
            name: business_name,
            code: business_cin
          }.to_json
        end

        class Act
          include ActiveModel::Model
          include ActiveModel::Validations

          attr_accessor(:id, :code, :name, :make_copy)
        end

        def should_validate_corporate_body?
          @current_step == 'subject_selection'
        end

        def corporate_body_selected?
          errors.add(:corporate_body, 'Zvoľte spoločnosť') unless @business_cin.present?
        end
      end
    end
  end
end
