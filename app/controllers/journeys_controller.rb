class JourneysController < ApplicationController
  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    @next_step = @journey.steps.order(:position).first
    load_newest_user_journey(current_user, @journey)
  end

  def start
    journey = Journey.find_by!(slug: params[:id])
    current_user.user_journeys.start!(journey)

    redirect_to journey
  end
end
