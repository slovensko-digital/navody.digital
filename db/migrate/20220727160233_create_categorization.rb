class CreateCategorization < ActiveRecord::Migration[6.1]
  def change
    create_table :categorizations do |t|
      t.references :categorizationable, polymorphic: true, index: true
    end
  end
end
