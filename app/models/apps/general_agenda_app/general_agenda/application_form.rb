module Apps
  module GeneralAgendaApp
    module GeneralAgenda
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :recipient_selected?
        validate :message_present?

        attr_accessor(
          :subject,
          :text,
          :recipient_name,
          :recipient_uri,
          :current_step,
          :back
        )

        def go_back?
          back == 'true'
        end

        def should_go_to_acts_list?
          @current_step == 'subject_selection' || (go_back? && @current_step == 'email')
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

        def recipient_selected?
          if @current_step == 'subject_selection' && recipient_uri.blank?
            errors.add(:recipient_name, 'Zvoľte prijímateľa')
          end
        end

        def message_present?
          if @current_step == 'message_form' && subject.blank?
            errors.add(:acts_list, 'Zadajte predmet')
          end
        end

        def message_present?
          if @current_step == 'message_form' && subject.blank?
            errors.add(:acts_list, 'Zadajte predmet')
          end
        end

        def subject_present?
          return unless (@current_step == 'email')

          if @email.present?
            errors.add(:email, 'Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk') unless @email.match?(URI::MailTo::EMAIL_REGEXP)
          else
            errors.add(:email, 'Zadajte emailovú adresu')
          end
        end
      end
    end
  end
end
