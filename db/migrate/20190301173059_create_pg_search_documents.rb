class CreatePgSearchDocuments < ActiveRecord::Migration[5.2]
  def self.up
    say_with_time("Creating table for pg_search multisearch") do
      create_table :pg_search_documents do |t|
        t.text :content
        t.tsvector :tsv_content
        t.belongs_to :searchable, :polymorphic => true, :index => true
        t.timestamps null: false
      end
    end
    add_index(:pg_search_documents, :tsv_content, using: 'gin')

    say_with_time("Adding trigger function on documents for updating tsv_content column") do

      sql = <<MIGRATION
          CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
          ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(tsv_content, 'pg_catalog.simple', content);
MIGRATION

      execute(sql)
    end

    Page.find_each do |p|
      p.save!
    end

    Journey.find_each do |j|
      j.save!
    end

    Step.find_each do |s|
      s.save!
    end

    # remove existing data columns and indexes
    remove_index :journeys, name: :journeys_fulltext_idx
    remove_index :steps, name: :steps_fulltext_idx
    remove_index :pages, name: :pages_fulltext_idx
    remove_column :journeys, :search_terms
    remove_column :steps, :search_terms
    remove_column :pages, :search_terms
  end

  def self.down
    add_column :journeys, :search_terms, :string
    add_column :steps, :search_terms, :string
    add_column :pages, :search_terms, :string

    create_index_statement = <<-SQL
      CREATE INDEX journeys_fulltext_idx ON journeys USING GIN (to_tsvector('simple', search_terms));
      CREATE INDEX steps_fulltext_idx ON steps USING GIN (to_tsvector('simple', search_terms));
      CREATE INDEX pages_fulltext_idx ON pages USING GIN (to_tsvector('simple', search_terms));
    SQL

    ActiveRecord::Base.connection.execute(create_index_statement)

    Page.find_each do |p|
      p.update!(search_terms: '')
    end

    Journey.find_each do |j|
      j.update!(search_terms: '')
    end

    Step.find_each do |s|
      s.update!(search_terms: '')
    end

    PgSearch::Document.find_each do |search|
      search.searchable.update!(search_terms: search.content)
    end

    change_column :journeys, :search_terms, :string, null: false
    change_column :steps, :search_terms, :string, null: false
    change_column :pages, :search_terms, :string, null: false

    say_with_time("Dropping table for pg_search multisearch") do
      drop_table :pg_search_documents
    end
  end
end
