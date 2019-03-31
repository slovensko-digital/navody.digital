class ReindexPgSearchTables < ActiveRecord::Migration[5.2]
  def up
    add_column :pg_search_documents, :keywords, :string
    add_column :pg_search_documents, :title, :string
    add_column :pg_search_documents, :tsv_keywords, :tsvector
    add_column :pg_search_documents, :tsv_title, :tsvector
    add_index :pg_search_documents, :tsv_keywords, using: 'gin'
    add_index :pg_search_documents, :tsv_title, using: 'gin'

    say_with_time("tsv_keywords_update") do
      sql = <<MIGRATION
          CREATE TRIGGER tsv_keywords_update BEFORE INSERT OR UPDATE
          ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(tsv_keywords, 'pg_catalog.simple', keywords);
MIGRATION

      execute(sql)
    end
    say_with_time("tsv_title_update") do
      sql = <<MIGRATION
          CREATE TRIGGER tsv_title_update BEFORE INSERT OR UPDATE
          ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(tsv_title, 'pg_catalog.simple', title);
MIGRATION

      execute(sql)
    end

    Journey.find_each do |j|
      j.save!
    end

    Page.find_each do |p|
      p.save!
    end

    Step.find_each do |s|
      s.save!
    end
  end

  def down
    remove_column :pg_search_documents, :keywords, :string
    remove_column :pg_search_documents, :title, :string
    remove_column :pg_search_documents, :tsv_keywords, :tsvector
    remove_column :pg_search_documents, :tsv_title, :tsvector
    execute('DROP TRIGGER tsv_keywords_update ON pg_search_documents;')
    execute('DROP TRIGGER tsv_title_update ON pg_search_documents;')
  end
end
