class AllowNilDescription < ActiveRecord::Migration[5.2]
  def change
    change_column_null :journeys, :description, true
  end
end
