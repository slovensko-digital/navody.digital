class AnonymousUser
  def logged_in?
    false
  end

  def create_notification_subscriptions(params)
    token = SecureRandom.uuid
    email = params[:email]
    params[:subscriptions].map do |type|
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: email)
      subscription.confirmation_token = token
      subscription.confirmation_sent_at = Time.now.utc
      subscription.save!
      subscription
    end

    NotificationSubscriptionMailer.with(email: email, token: token, types: params[:types]).confirmation_email
  end
end
