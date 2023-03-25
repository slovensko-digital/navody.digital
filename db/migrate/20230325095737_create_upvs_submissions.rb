class CreateUpvsSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table 'upvs.submissions' do |t|
      t.uuid :uuid, null: false
      t.string :title, null: false
      t.string :posp_id, null: false
      t.string :posp_version, null: false
      t.string :message_type, null: false
      t.string :message_subject, null: false
      t.string :recipient_uri, null: false
      t.string :sender_business_reference
      t.string :recipient_business_reference
      t.text :form, null: false
      t.string :token
      t.string :callback_url
      t.references :callback_step, foreign_key: { to_table: :steps }
      t.string :callback_step_status

      t.belongs_to :user, foreign_key: true
      t.uuid :anonymous_user_uuid

      t.timestamps
    end

    add_index 'upvs.submissions', [:user_id, :uuid], unique: true
    add_index 'upvs.submissions', [:anonymous_user_uuid, :uuid], unique: true
  end
end
