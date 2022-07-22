module UpvsSubmissions
  module Forms
    class ApplicationForDocumentCopy
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
        "00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk"
      end

      def posp_version
        "1.53"
      end

      def message_type
        "ks_340702"
      end

      def message_subject
        "Požiadanie o vyhotovenie kópie listiny uloženej v zbierke zákonom ustanovených listín obchodného registra"
      end

      def default_recipient_uri
        Rails.env.production? ? 'ico://sk/00166073_10006' : 'ico://sk/83369507'
      end

      def message_id
        @message_id ||= uuid
      end

      def correlation_id
        @correlation_id ||= uuid
      end

      private

      def build_form(form_params, builder: UpvsSubmissions::OrSrFormBuilder.new)
        {
          :encoding => 'XML',
          :content => builder.application_for_document_copy(form_params)
        }
      end

      delegate :uuid, to: self
    end
  end
end
