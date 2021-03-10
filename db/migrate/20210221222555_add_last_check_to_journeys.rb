class AddLastCheckToJourneys < ActiveRecord::Migration[6.0]
  def change
    add_column :journeys, :last_check, :date
  end
end
