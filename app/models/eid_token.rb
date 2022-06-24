class EidToken
  attr_reader :encoded_token
  attr_reader :public_key

  def initialize(encoded_token, public_key:)
    @encoded_token = encoded_token
    @public_key = public_key
  end

  def decoded_token
    @decoded_token ||= JWT.decode(encoded_token, OpenSSL::PKey::RSA.new(public_key), true, algorithms: ['RS256'])
  end

  def sub
    decoded_token.first.fetch('sub')
  end

  def expires_at
    Time.zone.at(decoded_token.first.fetch('exp'))
  end

  def expired?
    expires_at.past?
  end
end
