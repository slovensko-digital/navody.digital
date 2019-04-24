module NotificationSubscriptionsHelper
  def render_notification_subscription_component(subscription_types)
    group = NotificationSubscriptionGroup.new(subscription_types: subscription_types)
    group.user = current_user
    render partial: 'notification_subscriptions/form', object: group
  end
end
