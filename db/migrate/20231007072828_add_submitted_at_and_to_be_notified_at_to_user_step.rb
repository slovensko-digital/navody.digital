class AddSubmittedAtAndToBeNotifiedAtToUserStep < ActiveRecord::Migration[6.1]
  def change
    add_column :user_steps, :submitted_at, :date, default: nil
    add_column :user_steps, :to_be_notified_at, :date, default: nil
  end
end
