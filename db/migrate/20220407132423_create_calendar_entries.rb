class CreateCalendarEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_entries do |t|
      t.references :calendar_notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :event_date, null: false
      t.date :notification_date, null: false

      t.timestamps
    end
  end
end
