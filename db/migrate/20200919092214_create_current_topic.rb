class CreateCurrentTopic < ActiveRecord::Migration[6.0]
  def change
    create_table :current_topics do |t|
      t.string :body
      t.boolean :enabled
      t.timestamps
    end
  end
end
