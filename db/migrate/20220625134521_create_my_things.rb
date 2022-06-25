class CreateMyThings < ActiveRecord::Migration[6.1]
  def change
    create_table :my_things do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :identifier, null: false
      t.jsonb :custom_fields
      t.string :type, null: false

      t.timestamps
    end

    add_index :my_things, :identifier, unique: true
  end
end
