module UpvsSubmissions
  module Forms
    class GeneralAgenda
      include ActiveModel::Model

      attr_accessor :sender_uri, :recipient_uri, :sender_business_reference, :recipient_business_reference, :form, :attachments

      class << self
        delegate :uuid, to: SecureRandom
      end

      def initialize(recipient_uri: nil, sender_uri: nil, sender_business_reference: nil, recipient_business_reference: nil, form_params: nil)
        @sender_uri = sender_uri
        @recipient_uri = recipient_uri || default_recipient_uri
        @sender_business_reference = sender_business_reference
        @recipient_business_reference = recipient_business_reference
        @form = form_params ? build_form(form_params) : nil
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

      def build_form(form_params, builder: UpvsSubmissions::FormBuilders::GeneralAgendaFormBuilder)
        {
          :encoding => "XML",
          :content => builder.build_form(form_params)
        }
      end

      delegate :uuid, to: self
    end
  end
end
