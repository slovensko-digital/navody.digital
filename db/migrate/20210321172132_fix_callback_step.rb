class FixCallbackStep < ActiveRecord::Migration[6.1]
  def change
    change_column :submissions, :callback_step_path, 'bigint USING CAST(callback_step_path AS bigint)'
    rename_column :submissions, :callback_step_path, :callback_step_id
    add_foreign_key :submissions, :steps, column: :callback_step_id, on_delete: :cascade
  end
end
