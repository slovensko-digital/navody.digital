class Submissions::OboToken
  include ActiveModel::Model

  attr_accessor :jwt, :name, :expires_at

  def self.parse(jwt, public_key:)
    payload, _ = JWT.decode(value, public_key, true, algorithm: 'RS256', verify_expiration: true, verify_not_before: true)
    new(jwt: jwt, name: payload['name'], expires_at: Time.at(payload['exp'].to_i))
  end

  def expired?
    expires_at <= Time.current
  end

  alias_method :to_jwt, :jwt
end
