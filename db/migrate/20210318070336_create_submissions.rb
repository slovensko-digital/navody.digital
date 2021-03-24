class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.uuid :uuid, null: false
      t.belongs_to :user, foreign_key: true
      t.uuid :anonymous_user_uuid
      t.string :email
      t.string :callback_url, null: false
      t.references :callback_step, foreign_key: { to_table: :steps }
      t.string :callback_step_status
      t.string :selected_subscription_types, array: true, null: false, default: []
      t.jsonb :attachments
      t.jsonb :extra

      t.timestamps
    end

    add_index :submissions, [:user_id, :uuid], unique: true
    add_index :submissions, [:anonymous_user_uuid, :uuid], unique: true
  end
end
