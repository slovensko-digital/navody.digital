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

  # validates_presence_of :recipient_name, message: 'Vyplňte príjemcu podania', unless: -> { validation_context == :sign }
  # TODO validate token using public key & expirity
  # validate :recipient_uri_allowed, if: -> { recipient_uri.present? }

  def save
    return unless valid?
    # TODO submit the form else setup errors
    return true
  end

  def token_payload(token)
    JWT.decode(token, nil, false)
  end

  def recipient_name
    @recipient_uri
    # @recipient_name ||= Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).pluck(:name).first
  end

  def form_signed?
    !!signed_form
  end

  def signed_form
    return nil unless @signed_form_base64.present?
    @signed_form ||= Submissions::SignedForm.parse(@signed_form_base64)
  end

  def requires_signed_form?
    @require_signed_form
  end

  def schema

  end

  def visualisation
    transformation
  end

  def filename
    basename = URI(identifier).path.split('/')[-2]

    "#{basename}.xml"
  end

  private

  def egov_application_allowed
    unless EgovApplicationAllowRule.exists?(recipient_uri: @recipient_uri, posp_id: @posp_id, posp_version: @posp_version, message_type: @message_type)
      # TODO raise
    end
  end

  def transformation
    # TODO get template
    template = Nokogiri::XSLT(File.read("#{Rails.root}/template.xslt"))
    # document = Nokogiri::XML(@form)
    # TODO uncomment previous and delete next line
    document = Nokogiri::XML(File.read("#{Rails.root}/form.xml"))

    template.transform(document).to_s
  end

  def recipient_uri_allowed
    unless Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).exists?
      errors.add(:recipient_name, "Príjimateľ je neznámy")
    end
  end
end
