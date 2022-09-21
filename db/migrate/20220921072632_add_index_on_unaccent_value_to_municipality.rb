class AddIndexOnUnaccentValueToMunicipality < ActiveRecord::Migration[6.1]
  def change
    create_index_statement = <<-SQL
      CREATE OR REPLACE FUNCTION lower_unaccent(text) RETURNS text LANGUAGE SQL IMMUTABLE AS 'SELECT lower(unaccent($1))';
      CREATE INDEX unaccent_value_index ON code_list.municipalities (lower_unaccent(value));
    SQL

    ActiveRecord::Base.connection.execute(create_index_statement)
  end
end
