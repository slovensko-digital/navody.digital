class Admin::AdminController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch('ADMIN_USERNAME', 'admin'), password: ENV.fetch('ADMIN_PASSWORD', 'admin')
end
