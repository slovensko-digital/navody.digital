class AddImageNameToJourneys < ActiveRecord::Migration[5.2]
  def change
    add_column :journeys, :image_name, :text
  end
end
