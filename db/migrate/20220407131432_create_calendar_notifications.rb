class CreateCalendarNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_notifications do |t|
      t.references :calendar_topic, null: false, foreign_key: true
      t.references :step, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.string :type, null: false
      t.text :dates, array: true, default: []

      t.timestamps
    end
  end
end
