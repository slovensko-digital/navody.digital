class AddSubjectDataToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subject_name, :string
    add_column :users, :subject_cin, :string
    add_column :users, :subject_edesk_number, :string
  end
end
