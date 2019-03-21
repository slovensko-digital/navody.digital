class UserStepsController < ApplicationController
  before_action :require_user, except: [:show]

  def show
    @user_journey = UserJourney.find_by(id: params[:user_journey_id])
    redirect_to(root_path) and return unless @user_journey

    @journey = @user_journey.journey
    redirect_to(@journey) and return if @user_journey.user != current_user

    @user_step_by_steps = @user_journey.user_steps.index_by { |user_step| user_step.step }
    @steps = @journey.steps
    @current_step = @steps.find_by!(slug: params[:id])
    @user_task_by_tasks = @user_journey.user_tasks.index_by { |user_task| user_task.task }
  end

  def update
    @user_journey = current_user.user_journeys.find(params[:user_journey_id])
    step = @user_journey.journey.steps.find_by(slug: params[:id])
    @user_step = @user_journey.user_steps.find_or_initialize_by(step: step)
    @user_step.update(status: params['status'])


    respond_to do |format|
      format.html do
        redirect_to [@user_journey, step]
      end
      format.js do
        @steps = @user_journey.journey.steps
        @current_step = step
        @user_step_by_steps = @user_journey.user_steps.index_by { |user_step| user_step.step }
        @user_task_by_tasks = @user_journey.user_tasks.index_by { |user_task| user_task.task }
        render 'user_tasks/complete_or_undo'
      end
    end
  end
end
