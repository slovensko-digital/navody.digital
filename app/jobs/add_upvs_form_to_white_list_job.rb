class AddUpvsFormToWhiteListJob < ApplicationJob
  queue_as :default

  def perform(identifier, version, message_type, recipient_uri)
    Upvs::EgovApplicationAllowRule.find_or_create_by(
      posp_id: identifier,
      posp_version: version,
      message_type: message_type,
      recipient_uri: recipient_uri
    )

    xslt_document = get_form_xslt_document(identifier, version)

    Upvs::FormTemplateRelatedDocument.create_with(xslt_transformation: xslt_document).find_or_create_by(
      posp_id: identifier,
      posp_version: version,
      message_type: message_type,
    ) if xslt_document
  end

  private

  def get_form_xslt_document(identifier, version, type: 'CLS_F_XSLT_TXT_SGN', client: Faraday)
    params = {
      :identifier => identifier,
      :version => version,
      :type => type,
      :token => SkApiToken.api_token
    }

    response = client.get("#{ENV.fetch('SLOVENSKO_SK_API_URL')}/api/eform/form_template_related_document?#{params.to_query}")

    Base64.decode64(JSON.parse(response.body)["document"]) if response.status == 200
  end
end
