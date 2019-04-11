class UserStep < ApplicationRecord
  belongs_to :step
  belongs_to :user_journey

  has_many :user_tasks, dependent: :destroy

  scope :completed, -> { where(status: 'done') }

  validates :status, inclusion: { in: %w(not_started started waiting done) }

  def refresh_status
    if all_tasks_completed?
      update_attributes(status: 'done')
    elsif user_tasks.completed.none?
      update_attributes(status: 'not_started')
    else
      update_attributes(status: 'started')
    end
  end

  def done?
    status == 'done'
  end

  def waiting?
    status == 'waiting'
  end

  def all_tasks_completed?
    step.tasks.count == user_tasks.completed.count
  end
end
