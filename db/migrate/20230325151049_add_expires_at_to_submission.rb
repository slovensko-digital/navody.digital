class AddExpiresAtToSubmission < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :expires_at, :timestamp
  end
end
