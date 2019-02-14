class JourneysController < ApplicationController
  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    load_last_unfinished_journey(current_user, @journey)
  end
end
