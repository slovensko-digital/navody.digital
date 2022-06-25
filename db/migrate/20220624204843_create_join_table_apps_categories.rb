class CreateJoinTableAppsCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :apps, :categories do |t|
      # t.index [:app_id, :category_id]
      # t.index [:category_id, :app_id]
    end
  end
end
