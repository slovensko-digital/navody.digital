class AnonymousUser
  attr_reader :uuid

  def initialize(uuid)
    @uuid = uuid
  end

  def logged_in?
    false
  end

  def build_submission(params, extra)
    submission = Submission.new(params)
    submission.anonymous_user_uuid = @uuid
    submission.extra = params[:raw_extra] ? JSON.parse(params[:raw_extra]) : extra
    submission
  end

  def find_submission!(uuid)
    Submission.where(anonymous_user_uuid: self.uuid, uuid: uuid).first!
  end

  def create_notification_subscriptions(params)
    token = SecureRandom.uuid
    email = params[:email]
    params[:selected_subscription_types].each do |type|
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: email)
      subscription.confirmation_token = token
      subscription.confirmation_sent_at = Time.now.utc
      subscription.journey = Journey.find(params[:journey_id]) if params[:journey_id].present?
      subscription.save!
      subscription
    end

    NotificationSubscriptionMailer.with(email: email, token: token).confirmation_email
  end
end
