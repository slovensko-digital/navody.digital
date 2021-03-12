class NotificationSubscriptionsController < ApplicationController
  def index
    @metadata.og.image = 'og-subscriptions.jpg'
  end

  def create
    @group = NotificationSubscriptionGroup.of(user: current_user, **params[:notification_subscription_group])

    respond_to do |format|
      if @group.valid?
        @group.create_subscriptions

        format.html { redirect_to root_path }
        format.js #{ redirect_to params[:callback]}
      else
        format.js { render :new }
      end
    end
  end

  def confirm
    @subscriptions = NotificationSubscription.where(confirmation_token: params[:id])

    @subscriptions.each(&:confirm)
  end
end
