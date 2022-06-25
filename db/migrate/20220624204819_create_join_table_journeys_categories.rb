class CreateJoinTableJourneysCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :journeys, :categories do |t|
      # t.index [:journey_id, :category_id]
      # t.index [:category_id, :journey_id]
    end
  end
end
