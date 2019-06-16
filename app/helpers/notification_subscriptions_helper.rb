module NotificationSubscriptionsHelper
  def render_notification_subscription_component(subscription_types, journey_id = nil)
    group = NotificationSubscriptionGroup.new(subscription_types: subscription_types)
    group.user = current_user
    group.journey = journey_id
    render partial: 'notification_subscriptions/form', object: group
  end
end
