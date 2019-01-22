module UserStepsHelper
  def user_step_timeline_status_modifier(user_step)
    return 'not-done' unless user_step
    case user_step.status
    when 'done', 'waiting'
      user_step.status
    when 'started'
      'in-progress'
    else
      'not-done'
    end
  end
end
