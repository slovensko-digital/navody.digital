class JourneysController < ApplicationController
  def show
    @journey = Journey.find_by!(slug: params[:id])
  end
end
