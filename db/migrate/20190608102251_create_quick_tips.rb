class CreateQuickTips < ActiveRecord::Migration[5.2]
  def change
    create_table :quick_tips do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :body
      t.belongs_to :journey, foreign_key: true
      t.belongs_to :step, foreign_key: true
      t.string :application_slug
      t.string :application_title

      t.timestamps
    end

    add_index :quick_tips, :slug, unique: true
  end
end
