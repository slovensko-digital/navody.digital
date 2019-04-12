class AddTaskUrlTitle < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :url_title, :string
  end
end
