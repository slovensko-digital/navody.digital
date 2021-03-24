class Submissions::GeneralAgenda
  include ActiveModel::Model

  attr_accessor :recipient_uri, :recipient_name
  attr_accessor :subject
  attr_accessor :body
  attr_accessor :attachments
  attr_accessor :token
  attr_accessor :callback_url

  validates_presence_of :recipient_uri, message: 'Vyplňte príjemcu podania'
  validates_presence_of :subject, message: 'Vyplňte predmet podania'
  validates_presence_of :body, message: 'Vyplňte obsah podania'
  # TODO validate token using public key & expirity

  def save
    return unless valid?
    # TODO submit the form else setup errors
    return true
  end

  def token_payload
    @token_payload, _ = JWT.decode(@token, nil, false) unless @token_payload && @token
    @token_payload
  end
end
