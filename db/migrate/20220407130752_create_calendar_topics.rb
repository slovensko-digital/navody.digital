class CreateCalendarTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_topics do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
