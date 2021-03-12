class SendDoubleOptInEmailJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    raise 'Double opt-in failure: user already present' if subscription.user
    raise 'Double opt-in failure: token missing' unless subscription.confirmation_token
    raise 'Attempting to process subscription without email provided' unless subscription.email

    NotificationSubscription.transaction do
      confirmation_email = NotificationSubscriptionMailer.with(email: subscription.email, token: subscription.confirmation_token).confirmation_email
      confirmation_email.deliver_now

      subscription.touch(:confirmation_sent_at)
    end
  end
end