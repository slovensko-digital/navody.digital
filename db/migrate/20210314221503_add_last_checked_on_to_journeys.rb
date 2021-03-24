class AddLastCheckedOnToJourneys < ActiveRecord::Migration[6.0]
  def change
    add_column :journeys, :last_checked_on, :date
  end
end
