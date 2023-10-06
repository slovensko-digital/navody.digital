module Apps
  module GeneralAgendaApp
    module GeneralAgenda
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :recipient_present?
        validates :subject, presence: true, if: -> { current_step == 'fill_message' }
        validates :text, presence: true, if: -> { current_step == 'fill_message' }

        attr_accessor(
          :subject,
          :text,
          :recipient_name,
          :recipient_uri,
          :current_step,
        )

        def should_redirect_to_upvs_submission?
          current_step == 'fill_message' && valid?
        end

        private

        def recipient_present?
          errors.add(:recipient, 'Zvoľte prijímateľa') if recipient_uri.blank?
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
