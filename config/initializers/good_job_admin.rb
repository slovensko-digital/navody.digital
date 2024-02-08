GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  admin_username = Rails.application.config_for(:app).dig(:admin, :username)
  admin_password = Rails.application.config_for(:app).dig(:admin, :password)

  ActiveSupport::SecurityUtils.secure_compare(admin_username, username) &&
    ActiveSupport::SecurityUtils.secure_compare(admin_password, password)
end
