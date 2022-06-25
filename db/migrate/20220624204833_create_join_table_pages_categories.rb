class CreateJoinTablePagesCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :pages, :categories do |t|
      # t.index [:page_id, :category_id]
      # t.index [:category_id, :page_id]
    end
  end
end
