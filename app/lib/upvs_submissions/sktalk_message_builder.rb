class UpvsSubmissions::SktalkMessageBuilder
  class << self
    delegate :uuid, to: SecureRandom
  end

  XML_ENTITIES = HTMLEntities.new(:expanded)

  # TODO add #{build_attachment_objects(egov_application.attachments)} when attachments added to upvs_submission
  def build_sktalk_message(egov_application)
    <<~SKTALK
      <?xml version="1.0" encoding="utf-8"?>
      <SKTalkMessage xmlns="http://gov.sk/SKTalkMessage">
        <EnvelopeVersion>3.0</EnvelopeVersion>
        <Header>
          <MessageInfo>
            <Class>EGOV_APPLICATION</Class>
            <PospID>#{egov_application.posp_id}</PospID>
            <PospVersion>#{egov_application.posp_version}</PospVersion>
            <MessageID>#{egov_application.message_id}</MessageID>
            <CorrelationID>#{egov_application.correlation_id}</CorrelationID>
          </MessageInfo>
        </Header>
        <Body>
          <MessageContainer xmlns="http://schemas.gov.sk/core/MessageContainer/1.0">
            <MessageId>#{egov_application.message_id}</MessageId>
            <SenderId>#{egov_application.sender_uri}</SenderId>
            <RecipientId>#{egov_application.recipient_uri}</RecipientId>
            <MessageType>#{egov_application.message_type}</MessageType>
            <MessageSubject>#{sanitize(egov_application.message_subject)}</MessageSubject>
            #{build_business_references(egov_application) if references_present?(egov_application)}#{build_form_object(egov_application.form)}
          </MessageContainer>
        </Body>
      </SKTalkMessage>
    SKTALK
  end

  private

  def references_present?(egov_application)
    egov_application.sender_business_reference.present? || egov_application.recipient_business_reference.present?
  end

  def build_business_references(egov_application)
    separator = "\n      "
    [%Q{#{%Q{<SenderBusinessReference>#{egov_application.sender_business_reference}</SenderBusinessReference>} if egov_application.sender_business_reference.present?}},
     %Q{#{%Q{<RecipientBusinessReference>#{egov_application.recipient_business_reference}</RecipientBusinessReference>} + separator if egov_application.recipient_business_reference.present?}}].join(separator)
  end

  def build_form_object(form)
    build_object(content: format_xml_form(form), object_class: 'FORM')
  end

  def build_attachment_objects(attachments = [])
    separator = "\n      "
    (separator + attachments.map { |attachment| build_object(attachment) }.join(separator)) if attachments.present?
  end

  def build_object(id: uuid, name: 'Formulár.xml', description: nil, signed: false, mime_type: 'application/x-eform-xml', encoding: 'XML', content: nil, object_class: 'ATTACHMENT')
    %Q{<Object Id="#{id}"#{%Q{ Name="#{sanitize(name)}"} if name.present?}#{%Q{ Description="#{sanitize(description)}"} if description.present?} Class="#{object_class}"#{%Q{ IsSigned="#{signed}"} unless signed.nil?} MimeType="#{mime_type}" Encoding="#{encoding}">#{content}</Object>}
  end

  def format_xml_form(form)
    "\n        " + form.gsub("\n", "\n        ") + "\n      " if form
  end

  def sanitize(s)
    XML_ENTITIES.encode(s)
  end

  delegate :uuid, to: self
end
