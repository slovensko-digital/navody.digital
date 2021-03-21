class User < ApplicationRecord
  has_many :user_journeys do
    def start!(journey)
      create!(journey: journey)
    end
  end

  has_many :user_steps, through: :user_journeys
  has_many :user_tasks, through: :user_steps
  has_many :notification_subscriptions
  has_many :submissions

  def logged_in?
    true
  end

  def build_submission(params, extra:, skip_subscribe:)
    submission = submissions.build(params)
    submission.extra = params[:raw_extra] ? JSON.parse(params[:raw_extra]) : extra
    submission.skip_subscribe = skip_subscribe
    submission.current_user = self
    submission
  end

  def find_submission!(uuid)
    submissions.find_by!(uuid: uuid)
  end

  def update_step_status(step, status)
    user_journey = UserJourney.order(id: :desc).find_by(user: self, journey: step.journey) || user_journeys.create!(journey: step.journey)
    user_step = user_journey.user_steps.find_or_initialize_by(step: step)
    user_step.update(status: status)
  end
end
