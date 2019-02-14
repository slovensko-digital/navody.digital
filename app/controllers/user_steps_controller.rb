class UserStepsController < ApplicationController
  before_action :require_user
  before_action :find_user_journey

  def show
    @journey = @user_journey.journey
    @user_step_by_steps = @user_journey.user_steps.index_by { |user_step| user_step.step }
    @steps = @journey.steps
    @current_step = @steps.find_by!(slug: params[:id])
    @user_task_by_tasks = @user_journey.user_tasks.index_by { |user_task| user_task.task }
  end

  def update
    step = @user_journey.journey.steps.find_by(slug: params[:id])
    @user_step = @user_journey.user_steps.find_or_initialize_by(step: step)
    @user_step.update(status: params['status'])

    redirect_to [@user_journey, step]
  end

  def submit
    @step = @user_journey.journey.steps.find_by(slug: params[:id])
    @user_step = @user_journey.user_steps.find_or_initialize_by(step: @step)

    new_status = @step.is_waiting_step ? 'waiting' : 'done'
    @user_step.update!(status: new_status)

    redirect_to @step.submission_url
  end

  private

  def find_user_journey
    @user_journey = current_user.user_journeys.find(params[:user_journey_id])
  end
end
