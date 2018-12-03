class UserJourneysController < ApplicationController
  before_action :require_user

  Step = Struct.new(:id, :title, :status, :description)

  def create
    journey = Journey.find(params[:journey_id])

    user_journey = UserJourney.create!(
      user_id: current_user.id,
      journey_id: journey.id,
      started_at: DateTime.now,
    )

    redirect_to user_journey_path(user_journey, step_id: params[:step_id])
  end

  # TODO way too many variables for view
  def show
    @user_journey = current_user.user_journeys.find(params[:id])
    @journey = @user_journey.journey
    @steps = @journey.steps
    @step_status = StepStatus.new(@user_journey)

    if params[:step_id]
      @step = @user_journey.journey.steps.find(params[:step_id])
      @title = @step.title
      @text = @step.description
    else
      @title = @user_journey.journey.title
      @text = @user_journey.journey.description
    end
  end

end
