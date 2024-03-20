class AddWaitingTimeToSteps < ActiveRecord::Migration[6.1]
  def change
    add_column :steps, :waiting_time, :integer, default: 0
  end
end
