OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  client_id = Rails.application.config_for(:auth).dig('google', 'client_id')
  client_secret = Rails.application.config_for(:auth).dig('google', 'client_secret')

  provider :google_oauth2, client_id, client_secret
end

