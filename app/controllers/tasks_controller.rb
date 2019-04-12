class TasksController < ApplicationController
  before_action :require_user
  before_action :load_or_create_user_journey

  def complete
    update_state action_name
  end

  def undo
    update_state action_name
  end

  private

  def load_or_create_user_journey
    @journey = Journey.find_by_slug(params[:journey_id])
    # TODO remove completed
    @user_journey = UserJourney.order(id: :desc).find_by(user: current_user, journey: @journey) || current_user.user_journeys.create!(journey: @journey)
  end

  def update_state action
    task = @user_journey.journey.tasks.find(params[:id])

    user_step = @user_journey.user_steps.create_with(status: 'started').find_or_create_by(step: task.step)
    user_task = user_step.user_tasks.find_or_create_by(task: task)

    case action_name
    when 'complete'
      @user_journey.complete_task!(task)
    when 'undo'
      @user_journey.undo_task!(task)
    end

    respond_to do |format|
      format.html do
        redirect_to [@journey, user_step.step]
      end
      format.js do
        @steps = @user_journey.journey.steps
        @current_step = user_task.task.step
        @journey = @user_journey.journey
        @user_step_by_steps = @user_journey.user_steps.index_by { |user_step| user_step.step }
        @user_task_by_tasks = @user_journey.user_tasks.index_by { |user_task| user_task.task }
        render :complete_or_undo
      end
    end
  end
end
