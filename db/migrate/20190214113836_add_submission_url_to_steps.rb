class AddSubmissionUrlToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :submission_url, :string
  end
end
