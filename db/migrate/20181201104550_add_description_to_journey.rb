class AddDescriptionToJourney < ActiveRecord::Migration[5.2]
  def change
    add_column :journeys, :description, :text, null: false
  end
end
