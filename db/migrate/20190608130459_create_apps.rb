class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.text :title, null: false
      t.text :slug, null: false, unique: true
      t.text :image_name, null: false

      t.text :published_status, null: false

      t.text :description

      t.timestamps
    end
  end
end
