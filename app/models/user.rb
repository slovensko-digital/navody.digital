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

  def build_submission(params, extra)
    submission = submissions.build(params)
    submission.extra = params[:raw_extra] ? JSON.parse(params[:raw_extra]) : extra
    submission
  end

  def find_submission!(uuid)
    submissions.find_by!(uuid: uuid)
  end

  def create_notification_subscriptions(params)
    params[:selected_subscription_types].each do |type|
      subscription = notification_subscriptions.find_or_initialize_by(type: type)
      subscription.journey = Journey.find(params[:journey_id]) if params[:journey_id].present?
      subscription.confirm
      subscription
    end

    nil # no email action
  end
end
