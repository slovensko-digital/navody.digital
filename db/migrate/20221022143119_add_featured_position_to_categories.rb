class AddFeaturedPositionToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :featured_position, :integer, default: 0
  end
end
