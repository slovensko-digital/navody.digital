class UserJourneysController < ApplicationController
  before_action :require_user

  def restart
    user_journey = current_user.user_journeys.find(params[:id])

    redirect_to user_journey.restart!.journey
  end
end
