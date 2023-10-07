class UserStep < ApplicationRecord
  belongs_to :step
  belongs_to :user_journey

  has_many :user_tasks, dependent: :destroy

  scope :completed, -> { where(status: 'done') }

  validates :status, inclusion: { in: %w(not_started started waiting done) }

  def refresh_status
    if all_tasks_completed? && !step.has_app? && !step.is_waiting_step?
      update(status: 'done')
    elsif user_tasks.completed.none?
      update(status: 'not_started')
    else
      update(status: 'started')
    end
  end

  def update_status(new_status:)
    update(status: new_status, submitted_at: new_status == 'waiting' ? Date.today : nil)
  end

  def remaining_time
    step.waiting_time - (Date.today - submitted_at).to_i
  end

  def expected_resolution_date
    Date.today + remaining_time.days
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
