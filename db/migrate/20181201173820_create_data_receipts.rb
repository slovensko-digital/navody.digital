class CreateDataReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :data_receipts do |t|
      t.belongs_to :user, null: false
      t.belongs_to :task, null: false
      t.string :token, null: false
      t.text :received_payload
      t.text :received_data
      t.timestamp :generated_at, null: false
      t.timestamp :response_received_at
    end
  end
end
