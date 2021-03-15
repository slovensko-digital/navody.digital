module NotificationSubscriptionsHelper
  def render_notification_subscription_component(subscription_types, content: nil, &block)
    content = capture(&block) if block_given?
    group = NotificationSubscriptionGroup.of(subscription_types: subscription_types, user: current_user)

    render partial: 'notification_subscriptions/component', locals: { form: group, content: content }
  end

  def render_notification_subscription_fields(attributes, **options)
    group = options.delete(:group) || NotificationSubscriptionGroup.of(attributes, user: options.delete(:user))

    render partial: 'notification_subscriptions/form', locals: options.merge(form: group)
  end
end
