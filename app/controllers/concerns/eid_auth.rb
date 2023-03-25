module EidAuth
  extend ActiveSupport::Concern

  included do
    helper_method :eid_token
  end

  protected

  def eid_token
    eid_encoded_token = eid_encoded_token_from_session || eid_encoded_token_from_auth
    return unless eid_encoded_token.present?
    EidToken.new(eid_encoded_token, config: eid_config)
  end

  def eid_encoded_token_from_session
    session[:eid_encoded_token]
  end

  def eid_encoded_token_from_auth
    return unless auth_hash&.info.present?
    auth_hash.info['eid_encoded_token']
  end

  def eid_sub_from_auth
    return unless auth_hash&.info.present?
    auth_hash.info['eid_sub']
  end

  def eid_config
    Rails.application.config_for(:auth).fetch(:eid)
  end
end
