class JourneysController < ApplicationController
  layout "application"

  def show
    @journey = Journey.find_by!(slug: params[:slug])
  end
end
