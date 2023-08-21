# This file is used by Rack-based servers to start the application.

# Added que-web gem for showing job tracking
require 'que/web'

map '/admin/que' do
  run Que::Web
end

require_relative 'config/environment'
run Rails.application
