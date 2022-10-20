module Apps
  module OrSrApp
    module ActsSubmission
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :corporate_body_selected?
        validate :acts_selected?
        validate :email_present?

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
          @acts = array&.map do |act|
            Act.new(act)
          end
        end

        def encoded_note
          Base64.encode64(note.to_s)
        end

        def go_back?
          back == 'true'
        end

        def should_go_to_acts_list?
          @current_step == 'subject_selection' || (go_back? && @current_step == 'email')
        end

        def should_go_to_email?
          @current_step == 'acts'
        end

        def corporate_body_invalid?
          @current_step == 'subject_selection' && !valid?(:corporate_body)
        end

        def acts_invalid?
          @current_step == 'acts' && !valid?(:acts)
        end

        def email_invalid?
          @current_step == 'email' && !valid?(:email)
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

        def corporate_body_selected?
          if @current_step == 'subject_selection' && !@business_cin.present?
            errors.add(:corporate_body, 'Zvoľte spoločnosť')
          end
        end

        def acts_selected?
          if @current_step == 'acts' && !@acts.present?
            errors.add(:acts_list, 'Vyberte aspoň jednu listinu')
          end
        end

        def email_present?
          return unless (@current_step == 'email')

          if @email.present?
            errors.add(:email, 'Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk') unless @email.match?(URI::MailTo::EMAIL_REGEXP)
          else
            errors.add(:email, 'Zadajte emailovú adresu')
          end
        end

        class Act
          include ActiveModel::Model
          include ActiveModel::Validations

          attr_accessor(:id, :code, :name, :make_copy)
        end
      end
    end
  end
end
