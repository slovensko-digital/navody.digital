class AddAppUrlToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :app_url, :string
    add_column :steps, :type, :string, null: false, default: 'BasicStep'
  end
end
