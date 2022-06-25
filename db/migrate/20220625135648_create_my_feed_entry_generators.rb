class CreateMyFeedEntryGenerators < ActiveRecord::Migration[6.1]
  def change
    create_table :my_feed_entry_generators do |t|
      t.belongs_to :journey, foreign_key: true
      t.string :type, null: false

      t.timestamps
    end
  end
end
