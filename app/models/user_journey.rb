class UserJourney < ApplicationRecord
  belongs_to :journey
  belongs_to :user

  has_many :user_steps, dependent: :destroy
  has_many :user_tasks, through: :user_steps

  before_create {self.started_at = DateTime.current}

  def last_changed_step
    user_steps.joins(:step).order('user_steps.updated_at DESC').first.&step
  end

  def complete_task!(task)
    user_step = user_steps.create_with(status: 'started').find_or_initialize_by(step: task.step)
    user_task = user_step.user_tasks.find_or_initialize_by(task: task)
    user_task.completed_at = DateTime.current
    user_task.save!
    user_step.refresh_status
    user_task
  end

  def undo_task!(task)
    user_step = user_steps.create_with(status: 'started').find_or_initialize_by(step: task.step)
    user_task = user_step.user_tasks.find_or_initialize_by(task: task)
    user_task.completed_at = nil
    user_task.save!
    user_step.refresh_status
    user_task
  end

  def all_steps_completed?
    journey.steps.count == user_steps.completed.count
  end

  def restart!
    destroy!
  end
end
