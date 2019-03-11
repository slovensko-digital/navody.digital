require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NavodySlovenskoDigital
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.i18n.default_locale = :sk

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    app_config = Rails.application.config_for(:app)
    app_host = app_config.fetch('host', 'localhost')
    app_port = app_config.fetch('port', '')
    app_protocol = app_config.fetch('protocol', 'http')

    options = {
      host: app_host,
      protocol: app_protocol
    }

    if app_port.present?
      options[:port] = app_port.to_i
    end

    config.action_mailer.default_url_options = options

    config.active_record.schema_format = :sql
  end
end
