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
        validate :validate_attachments

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

          :is_submitted # Whether the form is submitted internally via the submit button or just open from POST request from external site (API functionality)
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

        # Process uploaded files and store them as blobs
        def attachments=(value)
          @attachments = {}

          value&.each do |index, value|
            index = index.to_i # Index submitted from form like `name="something[0]"` is treated as string

            # Check if the value is directly a blob's integer and then just use it
            if value.is_a?(Integer) || (value.is_a?(String) && /\A\d+\z/.match?(value))
              @attachments[index] = value
            elsif value.is_a?(ActionDispatch::Http::UploadedFile) # Upload the file and use the blob's ID
              attachment_template = attachments_template.try(:[], index)
              signed_required = UtilityService.yes?(attachment_template.try(:[], 'signed_required'))

              blob =  ActiveStorage::Blob.create_and_upload!(
                io: value.tempfile,
                filename: value.original_filename,
                metadata: {
                  original_template_name: attachment_template.try(:[], :name),
                  signed_required: signed_required
                }
              )

              @attachments[index] = blob.id
            end
          end
        end

        # attachments contains index->blob_id mapping like `{ 1 => 123, 2 => 456 }`
        # index represents index in the `attachments_template`
        #
        # This method returns actual `ActiveStorage::Blob` objects instead of IDs like:
        # { 1 => <ActiveStorage::Blob#123>, 2 => <ActiveStorage::Blob#456> }
        def attachment_blobs
          return @attachment_blobs unless @attachment_blobs.nil?

          blobs = ActiveStorage::Blob.where(id: attachments&.values).index_by(&:id)

          @attachment_blobs = attachments.to_h.transform_values { |blob_id| blobs[blob_id.to_i] }
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

        def validate_attachments
          attachments_template&.each_with_index do |attachment_template, index|
            if UtilityService.yes?(attachment_template[:required]) && attachments.to_h[index].blank?
              errors.add(:base, "Nahrajte povinnú prílohu pre '#{attachment_template[:name]}'")
            end
          end
        end
      end
    end
  end
end
