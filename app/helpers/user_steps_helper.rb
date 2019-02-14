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

  def user_step_switch_class(user_step, target_status)
    result = 'sdn-timeline-dropdown__option'
    result += ' sdn-timeline-dropdown__option--selected' if user_step && user_step.status == target_status
    result
  end
end
