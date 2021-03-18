class NotificationSubscriptionsController < ApplicationController
  def index
    @metadata.og.image = 'og-subscriptions.jpg'
  end

  def create
    @group = NotificationSubscriptionGroup.new(notification_group_params)
    @group.user = current_user
    @group.journey = Journey.find(params[:notification_subscription_group][:journey_id]) if params[:notification_subscription_group][:journey_id].present?

    respond_to do |format|
      if @group.save
        format.html { redirect_to root_path }
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def confirm
    @subscriptions = NotificationSubscription.where(confirmation_token: params[:id])
    @subscriptions.each do |subscription|
      subscription.confirm
    end
  end

  private

  def notification_group_params
    params.require(:notification_subscription_group).permit(
      :email,
      selected_subscription_types: [],
      subscription_types: []
    )
  end
end
