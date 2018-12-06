class UserTasksController < ApplicationController
  before_action :require_user

  def complete
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    task = user_journey.journey.tasks.find(params[:id])

    user_task = user_journey.complete_task!(task)

    if user_task.user_step.all_tasks_completed?
      redirect_to [user_journey, user_task.task.step.next_step]
    else
      redirect_to [user_journey, user_task.task.step]
    end

  end

  def undo
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    task = user_journey.journey.tasks.find(params[:id])

    user_task = user_journey.undo_task!(task)

    redirect_to [user_journey, user_task.task.step]
  end
end
