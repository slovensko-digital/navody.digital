class AddJourneyRefToNotificationSubscription < ActiveRecord::Migration[5.2]
  def change
    add_reference :notification_subscriptions, :journey, foreign_key: true
  end
end
