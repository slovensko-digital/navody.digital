class NotificationSubscriptionsController < ApplicationController
  def create
    @group = NotificationSubscriptionGroup.new
    @group.email = params[:notification_subscription_group][:email]
    @group.subscriptions = params[:notification_subscription_group][:subscriptions]
    @group.subscription_types = params[:notification_subscription_group][:subscription_types]
    @group.user = current_user

    respond_to do |format|
      if @group.valid?
        confirmation_email = current_user.create_notification_subscriptions(params[:notification_subscription_group])
        confirmation_email.deliver_later if confirmation_email
        format.html { redirect_to root_path }
        format.js
      else
        render :new
      end
    end
  end

  def confirm
    @subscriptions = NotificationSubscription.where(confirmation_token: params[:id])
    @subscriptions.each do |subscription|
      subscription.confirm
    end
  end
end
