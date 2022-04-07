class CreateCalendarSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :calendar_notification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
