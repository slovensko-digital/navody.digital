class EidToken
  attr_reader :encoded_token
  attr_reader :public_key

  def initialize(encoded_token, public_key:)
    @encoded_token = encoded_token
    @public_key = public_key
  end

  def decoded_token
    @decoded_token ||= JWT.decode(encoded_token, OpenSSL::PKey::RSA.new(public_key), true, algorithms: ['RS256'])
  rescue JWT::ExpiredSignature
    nil
  end

  def sub
    decoded_token&.first&.fetch('sub')
  end

  def name
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
    expires_at.past?
  end
end
