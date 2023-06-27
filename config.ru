# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require "que/web"

map "/que" do
  run Que::Web
end

run Rails.application
