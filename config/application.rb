require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NavodySlovenskoDigital
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    app_config = Rails.application.config_for(:app)
    app_host = app_config.fetch('host', 'localhost')
    app_port = app_config.fetch('port', 80).to_i
    app_protocol = app_config.fetch('protocol', 'http')

    config.action_mailer.default_url_options = {
      host: app_host,
      port: app_port,
      protocol: app_protocol
    }
  end
end
