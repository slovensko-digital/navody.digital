class Upvs::Submission
  include ActiveModel::Model

  attr_accessor :posp_id
  attr_accessor :posp_version
  attr_accessor :message_type
  attr_accessor :recipient_uri
  attr_accessor :sender_business_reference
  attr_accessor :recipient_business_reference
  attr_accessor :message_subject
  attr_accessor :form
  attr_accessor :attachments
  attr_accessor :token
  attr_accessor :callback_url

  validates_presence_of :posp_id, :posp_version, :message_type, :recipient_uri, :message_subject, :form
  validate :recipient_uri_allowed?, if: -> { Rails.env.production? }
  validate :egov_application_allowed?, if: -> { Rails.env.production? }
  validate :valid_xml_form?

  def save
    return unless valid?
    true
  end

  def sender_uri
    token&.sub
  end

  def recipient_name
    # return @recipient_uri unless Rails.env.production?
    @recipient_name ||= Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).pluck(:name).first
  end

  def message_id
    @message_id ||= SecureRandom.uuid
  end

  def correlation_id
    SecureRandom.uuid
  end

  def form_visualisation
    xslt_transformation
  end

  private

  def egov_application_allowed?
    unless Upvs::EgovApplicationAllowRule.exists?(recipient_uri: @recipient_uri, posp_id: @posp_id, posp_version: @posp_version, message_type: @message_type)
      errors.add(:disallowed_form_type, "Prijímateľ nie je oprávnený prijať daný typ podania")
    end
  end

  def xslt_transformation
    unless (form_related_document = Upvs::FormTemplateRelatedDocument.where(posp_id: @posp_id, posp_version: @posp_version, message_type: @message_type).first)
      # TODO raise error
    end

    xslt_template = Nokogiri::XSLT(form_related_document.xslt_transformation)

    xslt_template.transform(Nokogiri::XML(@form)).to_s.gsub('"', '\'')
  end

  def recipient_uri_allowed?
    unless Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).exists?
      errors.add(:recipient_name, "Príjimateľ je neznámy")
    end
  end

  def valid_xml_form?
    unless Nokogiri::XML(@form).errors.empty?
      errors.add(:form, "Nevalidný XML formulár")
    end
  end
end
