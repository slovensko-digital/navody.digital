class AddUserEmailIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :users, 'lower(email)', name: 'index_users_on_email_lower_unique', unique: true
  end
end
