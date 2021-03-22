class AddCallbackStepActionFields < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :submissions, column: :callback_step_id
    change_column :submissions, :callback_step_id, :string
    rename_column :submissions, :callback_step_id, :callback_step_path
  end
end
