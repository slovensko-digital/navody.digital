class UserTasksController < ApplicationController
  before_action :require_user

  def mark_as_complete
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    step = user_journey.journey.steps.find(params[:step_id])
    task = step.tasks.find(params[:task_id])

    user_step = UserStep.create_with(status: 'started').find_or_create_by!(
      user_journey_id: user_journey.id,
      step_id: step.id,
    )

    user_task = UserTask.find_or_initialize_by(
      task_id: task.id,
      user_step_id: user_step.id
    )

    user_task.completed_at = DateTime.now
    user_task.save!

    redirect_to user_journey_path(user_journey, step_id: step.id), notice: 'Označenie prebehlo úspešne'
  end

  def mark_as_incomplete
    user_journey = current_user.user_journeys.find(params[:user_journey_id])
    step = user_journey.journey.steps.find(params[:step_id])
    task = step.tasks.find(params[:task_id])

    user_step = UserStep.find_by!(
      user_journey_id: user_journey.id,
      step_id: step.id,
    )

    user_task = UserTask.find_by!(
      task_id: task.id,
      user_step_id: user_step.id
    )

    user_task.completed_at = nil
    user_task.save!

    redirect_to user_journey_path(user_journey, step_id: step.id), notice: 'Zrušenie prebehlo úspešne'
  end
end