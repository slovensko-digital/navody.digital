class ChangeFeaturedPositionNullOnJourneys < ActiveRecord::Migration[5.2]
  def change
    Journey.where(featured_position: nil).update_all(featured_position: 0)
    change_column :journeys, :featured_position, :integer, null: false, default: 0
  end
end
