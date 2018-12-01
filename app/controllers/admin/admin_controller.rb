class Admin::AdminController < ApplicationController
  http_basic_authenticate_with(
      name: Rails.application.config_for(:app).dig('admin', 'username'),
      password: Rails.application.config_for(:app).dig('admin', 'password'),
  )
end
