class UserStep < ApplicationRecord
  belongs_to :step
  belongs_to :user_journey

  has_many :user_tasks, dependent: :destroy

  scope :completed, -> { where(status: 'done') }

  validates :status, inclusion: { in: %w(not_started started waiting done) }

  def to_param
    step.slug
  end

  def refresh_status
    if all_tasks_completed?
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
