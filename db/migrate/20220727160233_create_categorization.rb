class CreateCategorization < ActiveRecord::Migration[6.1]
  def change
    create_table :categorizations do |t|
      t.references :categorizable, polymorphic: true, index: true
    end

    create_join_table :categories, :categorizations
    add_index :categories_categorizations, [:category_id, :categorization_id], unique: true, name: 'index_categories_categorizations'

    Journey.all.each do |j|
      j.categorization = Categorization.new(categorizable: j)
    end

    Page.all.each do |p|
      p.categorization = Categorization.new(categorizable: p)
    end

    App.all.each do |a|
      a.categorization = Categorization.new(categorizable: a)
    end
  end
end
