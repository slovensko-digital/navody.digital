class AddFullTextIndicesToPages < ActiveRecord::Migration[5.2]
  def up
    add_column :pages, :search_terms, :string

    Page.find_each do |page|
      page.save!
    end

    create_index_statement = <<-SQL
      CREATE INDEX pages_fulltext_idx ON pages USING GIN (to_tsvector('simple', search_terms));
    SQL

    ActiveRecord::Base.connection.execute(create_index_statement)

    change_column :pages, :search_terms, :string, null: false
  end

  def down
    remove_column :pages, :search_terms
  end
end
