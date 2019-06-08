class AddCustomTitleToSteps < ActiveRecord::Migration[5.2]
  def up
    add_column :steps, :custom_title, :string
  end

  def down
    remove_column :steps, :custom_title
  end
end
