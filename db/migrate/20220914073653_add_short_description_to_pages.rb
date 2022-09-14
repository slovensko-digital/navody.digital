class AddShortDescriptionToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :short_description, :text
  end
end
