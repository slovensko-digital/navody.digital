module UserStepsHelper
  def user_step_timeline_status_class(user_step)
    return 'nothing' unless user_step
    case user_step.status
    when 'done', 'waiting'
      user_step.status
    when 'started'
      'in-progress'
    else
      'nothing'
    end
  end
end
