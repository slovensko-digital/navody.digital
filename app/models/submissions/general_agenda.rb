class Submissions::GeneralAgenda
  include ActiveModel::Model

  attr_accessor :recipient_uri
  attr_accessor :subject
  attr_accessor :body
  attr_accessor :attachments
  attr_accessor :token
  attr_accessor :callback_url

  validates_presence_of :recipient_uri, message: 'Vyplňte príjemcu podania'
  validates_presence_of :subject, message: 'Vyplňte predmet podania'
  validates_presence_of :body, message: 'Vyplňte obsah podania'
  # TODO validate token using public key & expirity
  validate :recipient_uri_allowed, if: -> { recipient_uri.present? }

  def save
    return unless valid?
    # TODO submit the form else setup errors
    return true
  end

  def token_payload
    @token_payload, _ = JWT.decode(@token, nil, false) unless @token_payload && @token
    @token_payload
  end

  def recipient_name
    @recipient_name ||= Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).pluck(:name).first
  end

  private

  def recipient_uri_allowed
    unless Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).exists?
      errors.add(:recipient_name, "Príjimateľ je neznámy")
    end
  end
end
