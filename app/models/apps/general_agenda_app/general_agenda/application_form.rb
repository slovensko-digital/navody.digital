module Apps
  module GeneralAgendaApp
    module GeneralAgenda
      class ApplicationForm
        include ActiveModel::Model
        include ActiveModel::Validations

        validate :validate_recipient_present
        validate :validate_subject
        validate :validate_text
        validate :validate_placeholders

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
          :is_submitted,
          # TODO: :files,
        )

        # `signed_required` is stored as string and this method converts it into boolean
        def signed_required?
          UtilityService.yes?(signed_required)
        end

        def template_errors
          @template_errors || []
        end

        def valid_template?
          @template_errors = []

          if attachments_template.present? && !attachments_template.is_a?(Array)
            @template_errors << 'Premenná "attachments_template" musí byť pole súborov.'
          elsif attachments_template.is_a?(Array)
            attachments_template.each_with_index do |attachment_template, index|
              @template_errors << "Hodnota \"name\" pre #{index + 1} attachments_template musí byť povinne text." if attachment_template[:name].blank? || !attachment_template[:name].is_a?(String)
              @template_errors << "Hodnota \"description\" pre #{index + 1} attachments_template má byť text." if attachment_template[:description].present? && !attachment_template[:description].is_a?(String)
              @template_errors << "Hodnota \"required\" pre #{index + 1} attachments_template musí byť 1 alebo 0." unless attachment_template[:required].in?(['1', '0', nil, ''])
              @template_errors << "Hodnota \"signed_required\" pre #{index + 1} attachments_template musí byť 1 alebo 0." unless attachment_template[:signed_required].in?(['1', '0', nil, ''])
            end
          end

          @template_errors << "Hodnota \"signed_required\" musí byť 1 alebo 0." unless signed_required.in?(['1', '0', nil, ''])

          @template_errors.blank?
        end

        def attachments=(value)
          value # TODO
        end

        private

        def validate_recipient_present
          errors.add(:recipient_name, 'Zvoľte prijímateľa') if recipient_name.blank? || recipient_uri.blank?
        end

        def validate_subject
          errors.add(:subject, 'Predmet je povinná položka') if subject.blank?
        end

        def validate_text
          errors.add(:text, 'Text je povinná položka') if text.blank?
        end

        def validate_placeholders
          pattern = /\{[^{}\s]+}/ # Define a regex pattern to match {PLACEHOLDER} without spaces within the text

          # Check if the text contains any placeholders
          if pattern.match(text)
            placeholders = text.scan(pattern).uniq

            errors.add(:text, "Prosím nahraďte #{placeholders.join(', ')} za skutočnú hodnotu.")
          end
        end
      end
    end
  end
end
