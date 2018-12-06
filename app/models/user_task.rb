class UserTask < ApplicationRecord
  belongs_to :task
  belongs_to :user_step

  scope :completed, -> { where.not(completed_at: nil) }

  def completed?
    !!completed_at
  end

  def complete!
    update_attributes!(completed_at: Time.now)
  end

  def undo!
    update_attributes!(completed_at: nil)
  end
end
