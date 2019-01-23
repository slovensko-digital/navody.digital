class UserTasksController < ApplicationController
  before_action :require_user

  def complete
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    task = user_journey.journey.tasks.find(params[:id])

    user_task = user_journey.complete_task!(task)

    redirect_to [user_journey, user_task.task.step]
  end

  def undo
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    task = user_journey.journey.tasks.find(params[:id])

    user_task = user_journey.undo_task!(task)

    redirect_to [user_journey, user_task.task.step]
  end
end
