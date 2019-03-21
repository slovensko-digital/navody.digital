class JourneysController < ApplicationController
  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    @next_step = @journey.steps.order(:position).first
    load_last_unfinished_journey(current_user, @journey)

    redirect_to @unfinished_user_journey unless @unfinished_user_journey.blank?
  end
end
