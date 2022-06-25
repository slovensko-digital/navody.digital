class CreateMyUserFeedEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :my_user_feed_entries do |t|
      t.belongs_to :user, null: false
      t.belongs_to :my_thing, null: false, foreign_key: true
      t.string :identifier, null: false
      t.string :status, null: false
      t.datetime :deadline_at
      t.jsonb :custom_fields
      t.belongs_to :journey, foreign_key: true
      t.datetime :last_checked_at
      t.string :type, null: false

      t.timestamps
    end

    add_index :my_user_feed_entries, :identifier, unique: true
    add_foreign_key :my_user_feed_entries, :users, on_delete: :cascade
  end
end
