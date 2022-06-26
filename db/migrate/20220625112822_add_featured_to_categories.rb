class AddFeaturedToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :featured, :boolean, default: true
  end
end
