class CreateJoinTableCategoriesCategorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_categorizations, id: false do |t|
      t.bigint :category_id
      t.bigint :categorization_id
    end

    add_index :categories_categorizations, :category_id
    add_index :categories_categorizations, :categorization_id
  end
end
