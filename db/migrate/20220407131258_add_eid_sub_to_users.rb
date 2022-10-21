class AddEidSubToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :eid_sub, :string, null: true
    add_index :users, :eid_sub
  end
end
