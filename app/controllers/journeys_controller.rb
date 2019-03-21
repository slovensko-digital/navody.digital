class JourneysController < ApplicationController
  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    load_last_unfinished_journey(current_user, @journey)

    if @unfinished_user_journey && @unfinished_user_journey.current_step
      redirect_to user_journey_step_path(@unfinished_user_journey, @unfinished_user_journey.current_step) and return
    end
  end
end
