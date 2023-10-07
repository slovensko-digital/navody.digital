module Apps
  module GeneralAgendaApp
    module GeneralAgenda
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :recipient_present?
        validates :subject, presence: true
        validates :text, presence: true

        attr_accessor(
          # Static/template attributes
          :title,
          :description,
          :attachments_template,

          # Submitted through form
          :recipient_name,
          :recipient_uri,
          :subject,
          :text,
          :text_hint,
          :signed_required,
          :attachments,
          :is_submitted
        )

        private

        def recipient_present?
          errors.add(:recipient_name, 'Zvoľte prijímateľa') if recipient_name.blank? || recipient_uri.blank?
        end
      end
    end
  end
end
