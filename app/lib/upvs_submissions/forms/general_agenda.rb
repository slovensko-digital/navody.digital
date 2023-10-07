module UpvsSubmissions
  module Forms
    class GeneralAgenda
      include ActiveModel::Model

      attr_accessor :application_form, :form_blob_id, :attachments

      delegate :recipient_uri, to: :application_form

      class << self
        delegate :uuid, to: SecureRandom
      end

      def initialize(application_form)
        @application_form = application_form
        @form_blob_id = create_form_attachment
        @attachments = []
      end

      def posp_id
        "App.GeneralAgenda"
      end

      def posp_version
        "1.9"
      end

      def message_type
        "App.GeneralAgenda"
      end

      def message_subject
        "Všeobecná agenda"
      end

      def message_id
        @message_id ||= uuid
      end

      def correlation_id
        @correlation_id ||= uuid
      end

      def attachments_blob_ids
        application_form.attachments.to_h.values.map(&:to_i)
      end

      private

      delegate :uuid, to: self

      def create_form_attachment
        document_xml = UpvsSubmissions::FormBuilders::GeneralAgendaFormBuilder.build_form(application_form)

        blob = ActiveStorage::Blob.create_and_upload!(
          io: StringIO.new(document_xml.to_xml),
          filename: 'Dokument.xml', # This is how the XML is called in slovensko.sk
          content_type: 'application/x-eform-xml', # Mandatory content type for the Autogram and UPVS app. See `Upvs::SubmissionsController#signing_data`
          metadata: { signed_required: application_form.signed_required? }
        )

        blob.id
      end
    end
  end
end
