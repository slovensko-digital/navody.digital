class EidToken
  attr_reader :encoded_token
  attr_reader :config

  def initialize(encoded_token, config:)
    @encoded_token = encoded_token
    @config = config
  end

  def decoded_token
    @decoded_token ||= JWT.decode(encoded_token, public_key, true, algorithms: ['RS256'])
  rescue JWT::ExpiredSignature
    nil
  end

  def sub
    decoded_token&.first&.fetch('actor')&.fetch('sub')
  end

  def name
    decoded_token&.first&.fetch('actor')&.fetch('name')
  end

  def subject_sub
    decoded_token&.first&.fetch('sub')
  end

  def subject_name
    decoded_token&.first&.fetch('name')
  end

  def expires_at
    exp = decoded_token&.first&.fetch('exp')
    if exp.present?
      Time.zone.at(exp)
    else
      nil
    end
  end

  def expired?
    expires_at.nil? ? true : expires_at.past?
  end

  def valid?
    !expired?
  end

  def api_token(expires_in: 3.minutes)
    JWT.encode({ exp: (Time.zone.now + expires_in).to_i, jti: SecureRandom.uuid, obo: encoded_token }, private_key, 'RS256', { cty: 'JWT' })
  end

  def generate_logout_url(expires_in: 3.minutes)
    (base_url + URI("/logout?token=#{api_token(expires_in: expires_in)}")).to_s
  end

  private

  def base_url
    URI(config[:base_url])
  end

  def public_key
    OpenSSL::PKey::RSA.new(config[:public_key])
  end

  def private_key
    OpenSSL::PKey::RSA.new(config[:private_key])
  end
end
