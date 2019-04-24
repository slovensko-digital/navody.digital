class CreateNotificationSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_subscriptions do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.string :email
      t.string :type, null: false
      t.uuid :confirmation_token, index: true
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
