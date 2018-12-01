# user for view, to make it more readable
class StepStatus
  def initialize(user_journey)
    # avoid n+1 query
    by_step = user_journey.user_steps.to_a.map { |user_step| [user_step.step_id, user_step] }
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
    'HOTOVO'
  end

  def started
    'ROZPRACOVANÁ'
  end

  def waiting
    'ČAKÁME'
  end

  def nothing
    'NIČ'
  end
end
