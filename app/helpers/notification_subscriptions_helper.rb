module NotificationSubscriptionsHelper
  def render_notification_subscription_component(subscription_types, journey: nil)
    group = NotificationSubscriptionGroup.new(subscription_types: subscription_types)
    group.user = current_user
    group.journey = journey
    render partial: 'notification_subscriptions/form', layout: 'notification_subscriptions/layout', object: group
  end
end
