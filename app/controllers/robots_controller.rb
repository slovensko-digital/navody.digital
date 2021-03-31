class RobotsController < ApplicationController
  layout false

  def index
    render Rails.env.production? ? 'allow' : 'disallow'
  end
end
