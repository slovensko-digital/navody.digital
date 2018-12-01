class AddPositionAttribute < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :position, :integer, null: false, default: 0
    add_column :journeys, :position, :integer, null: false, default: 0
    add_column :steps, :position, :integer, null: false, default: 0
    add_column :tasks, :position, :integer, null: false, default: 0
  end
end
