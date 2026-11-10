# frozen_string_literal: true

Altcha.setup do |config|
  config.algorithm = 'SHA-256'
  # was num_range = (30_000..45_000), i.e. 15k possibilities
  config.max_number = 15_000
  config.timeout = 5.minutes
  config.hmac_key = Rails.application.config_for(:auth).dig(:altcha, :hmac_key)
end
