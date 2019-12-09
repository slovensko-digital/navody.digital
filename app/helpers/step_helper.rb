module StepHelper
  def destroy_step_link(step)
    recently_active_steps = UserStep.recently_active.joins(:step).where(steps: { id: step.id }).count

    confirmation_text = if recently_active_steps > 0
                          "This step has been recently active for #{recently_active_steps} user. Are you sure you wish to delete this step from the journey?"
                        else
                          'Are you sure?'
                        end

    link_to 'Destroy', [:admin, step.journey, step], method: :delete, data: { confirm: confirmation_text }
  end
end
