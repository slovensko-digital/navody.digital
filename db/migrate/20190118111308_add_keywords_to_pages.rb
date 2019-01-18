class AddKeywordsToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :keywords, :text
  end
end
