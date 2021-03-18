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
    submission
  end

  def find_submission!(uuid)
    submissions.find_by!(uuid: uuid)
  end
end
