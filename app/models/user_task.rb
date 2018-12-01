class UserTask < ApplicationRecord
  belongs_to :task
  belongs_to :user_step

  def completed?
    !!completed_at
  end
end
