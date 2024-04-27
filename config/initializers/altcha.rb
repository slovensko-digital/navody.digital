# frozen_string_literal: true

Altcha.setup do |config|
  config.algorithm = 'SHA-256'
  config.num_range = (50_000..300_000)
  config.timeout = 5.minutes
  config.hmac_key = 'dfa06d467a84fea13941f1c52c38c6458a67617a'
end
