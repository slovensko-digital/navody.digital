class User < ApplicationRecord
  has_many :user_journeys do
    def start!(journey)
      create!(journey: journey)
    end
  end

  has_many :user_steps, through: :user_journeys
  has_many :user_tasks, through: :user_steps
  has_many :notification_subscriptions

  def logged_in?
    true
  end

  def create_notification_subscriptions(params)
    params[:subscription_types].each do |type|
      subscription = notification_subscriptions.find_or_initialize_by(type: type)
      subscription.journey = Journey.find(params[:journey_id]) if params[:journey_id].present?
      subscription.confirm
      subscription
    end

    nil # no email action
  end
end
