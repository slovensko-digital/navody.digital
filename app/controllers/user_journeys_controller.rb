class UserJourneysController < ApplicationController
  before_action :require_user

  def restart
    user_journey = current_user.user_journeys.find(params[:id])

    redirect_to user_journey.restart!.journey
  end

  def in_process
    @user_journeys = current_user.user_journeys.all do |user_journey|
      !user_journey.all_steps_completed?
    end
  end
end
