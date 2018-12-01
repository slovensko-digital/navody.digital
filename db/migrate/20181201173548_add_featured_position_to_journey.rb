class AddFeaturedPositionToJourney < ActiveRecord::Migration[5.2]
  def change
    add_column :journeys, :featured_position, :integer, null: true, default: nil
  end
end
