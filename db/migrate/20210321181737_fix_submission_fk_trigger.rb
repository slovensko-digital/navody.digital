class FixSubmissionFkTrigger < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :submissions, :steps, column: :callback_step_id # remove cascade
    add_foreign_key :submissions, :steps, column: :callback_step_id, on_delete: :nullify
  end
end
