class SkApiToken
  def self.api_token(sub: ENV.fetch('SLOVENSKO_SK_API_EFORM_SUB'), expires_in: 3.minutes)
    JWT.encode({ exp: (Time.zone.now + expires_in).to_i, jti: SecureRandom.uuid, sub: sub }, private_key, 'RS256')
  end

  private

  def self.private_key
    OpenSSL::PKey::RSA.new(config[:private_key])
  end

  def self.config
    Rails.application.config_for(:auth).fetch(:eid)
  end
end
