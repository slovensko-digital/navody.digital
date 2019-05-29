class AddCustomTitleToSteps < ActiveRecord::Migration[5.2]
  def up
    add_column :steps, :custom_title, :string, {:default => nil}
  end

  def down
    remove_column :steps, :custom_title
  end
end
