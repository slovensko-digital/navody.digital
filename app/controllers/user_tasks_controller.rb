class UserTasksController < ApplicationController
  before_action :require_user


  def toggle_complete
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    task = user_journey.journey.tasks.find(params[:id])

    user_step = user_journey.user_steps.create_with(status: 'started').find_or_create_by(step: task.step)
    user_task = user_step.user_tasks.find_or_create_by(task: task)

    if user_task.completed?
      user_journey.undo_task!(task)
    else
      user_journey.complete_task!(task)
    end

    respond_to do |format|
      format.html do
        redirect_to [user_journey, user_task.task.step]
      end
      format.js do
        @steps = user_journey.journey.steps
        @current_step = @steps.find(params[:current_step])
        @user_journey = user_journey
        @user_step_by_steps = user_journey.user_steps.index_by { |user_step| user_step.step }
        @user_task_by_tasks = user_journey.user_tasks.index_by { |user_task| user_task.task }
      end
    end
  end
end
