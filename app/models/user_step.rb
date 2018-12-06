class UserStep < ApplicationRecord
  belongs_to :step
  belongs_to :user_journey

  has_many :user_tasks

  def refresh_status
    if step.tasks.count == user_tasks.completed.count
      update_attributes(status: 'done')
    elsif user_tasks.completed.count == 0
      update_attributes(status: 'nothing')
    else
      update_attributes(status: 'started')
    end
  end

  def all_tasks_completed?
    step.tasks.count == user_tasks.completed.count
  end
end
