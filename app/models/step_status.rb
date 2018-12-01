# user for view, to make it more readable
class StepStatus
  def initialize(user_journey)
    # avoid n+1 query
    by_step = user_journey.user_steps.includes(:user_tasks).to_a.map { |user_step| [user_step.step_id, user_step] }
    @user_steps_by_step_id = Hash[by_step]
  end

  def status_for(step)
    user_step = @user_steps_by_step_id.fetch(step.id, nil)
    if user_step
      public_send(user_step.status)
    else
      nothing
    end
  end

  # TODO make this nice!
  def done
    'done'
  end

  def started
    'in-progress'
  end

  def waiting
    'waiting'
  end

  def nothing
    'not-done'
  end

  # TODO export to better place
  def complete?(step:, task:)
    user_step = @user_steps_by_step_id.fetch(step.id, nil)
    return false unless user_step

    # N+1 query !!
    user_task = UserTask.find_by(user_step_id: user_step.id, task_id: task.id)

    return false unless user_task

    user_task.completed?
  end
end
