class JourneysController < ApplicationController
  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    @next_step = @journey.steps.order(:position).first
    load_newest_user_journey(current_user, @journey)
  end
end
