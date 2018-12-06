class UserStepsController < ApplicationController
  before_action :require_user

  def show
    @user_journey = current_user.user_journeys.find(params[:user_journey_id])
    @journey = @user_journey.journey
    @user_step_by_steps = @user_journey.user_steps.index_by { |user_step| user_step.step }
    @steps = @journey.steps
    @current_step = @steps.find_by!(slug: params[:id])
    @user_task_by_tasks = @user_journey.user_tasks.index_by { |user_task| user_task.task }
  end
end
