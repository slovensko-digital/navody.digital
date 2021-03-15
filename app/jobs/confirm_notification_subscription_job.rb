class ConfirmNotificationSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    list_name = NotificationSubscription::TYPES[subscription.type]
    raise "Invalid contacts list name: #{list_name}" unless list_name

    raise "Subscription not valid: #{subscription.errors}" unless subscription.valid?

    NotificationSubscription.transaction do
      AddEmailToContactListJob.perform_now(email, list_name)

      subscription.user = User.find_or_create_by!(email: subscription[:email])
      subscription.touch(:confirmed_at) unless subscription.confirmed_at
      subscription.save!
    end
  end
end