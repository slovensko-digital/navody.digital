class AddShortDescriptionToJourneys < ActiveRecord::Migration[6.1]
  def change
    add_column :journeys, :short_description, :text
  end
end
