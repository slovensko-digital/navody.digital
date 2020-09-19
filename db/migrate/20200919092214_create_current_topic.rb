class CreateCurrentTopic < ActiveRecord::Migration[6.0]
  def change
    create_table :current_topics do |t|
      t.string :key, null: false
      t.string :value
      t.boolean :enabled
      t.timestamps
    end
  end
end
