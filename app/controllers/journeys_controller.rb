class JourneysController < ApplicationController
  def show
    @journey = Journey.find_by!(slug: params[:id])

    if current_user
      @user_journey = UserJourney.find_by(user: current_user, journey: @journey)
      redirect_to @user_journey if @user_journey.present?
    end
  end
end
