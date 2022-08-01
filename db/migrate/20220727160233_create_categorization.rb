class CreateCategorization < ActiveRecord::Migration[6.1]
  def change
    create_table :categorizations do |t|
      t.references :categorizable, polymorphic: true, index: true
    end

    create_table :categories_categorizations, id: false do |t|
      t.belongs_to :category, foreign_key: true
      t.belongs_to :categorization, foreign_key: true
    end

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
