class CreateUpvsEgovApplicationAllowRule < ActiveRecord::Migration[6.1]
  def change
    create_table 'upvs.egov_application_allow_rules' do |t|
      t.string :recipient_uri, null: false
      t.string :posp_id, null: false
      t.string :posp_version, null: false
      t.string :message_type, null: false

      t.timestamps
    end
  end
end
