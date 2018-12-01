class AddUrlToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :url, :text
  end
end
