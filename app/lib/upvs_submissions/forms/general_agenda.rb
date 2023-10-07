module UpvsSubmissions
  module Forms
    class GeneralAgenda
      include ActiveModel::Model

      attr_accessor :sender_uri, :recipient_uri, :sender_business_reference, :recipient_business_reference, :form_blob_id, :attachments

      class << self
        delegate :uuid, to: SecureRandom
      end

      def initialize(recipient_uri: nil, sender_uri: nil, sender_business_reference: nil, recipient_business_reference: nil, form_params: nil)
        @sender_uri = sender_uri
        @recipient_uri = recipient_uri || default_recipient_uri
        @sender_business_reference = sender_business_reference
        @recipient_business_reference = recipient_business_reference
        @form_blob_id = form_params ? create_form_attachment(form_params) : nil
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

      def default_recipient_uri
        (Rails.env.production? || Rails.env.staging?) ? "ico://sk/00166073_10006" : "ico://sk/83369507"
      end

      def message_id
        @message_id ||= uuid
      end

      def correlation_id
        @correlation_id ||= uuid
      end

      private

      delegate :uuid, to: self

      def create_form_attachment(form_params)
        form = UpvsSubmissions::FormBuilders::GeneralAgendaFormBuilder.build_form(form_params)
        filename = 'exam.xml' # TODO: change to random generated

        blob = ActiveStorage::Blob.create_and_upload!(
          io: StringIO.new(form.to_xml),
          filename: filename,
          content_type: 'application/xml'
        )

        blob.id
      end
    end
  end
end
