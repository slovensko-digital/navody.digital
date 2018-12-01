class AddFulltextIndices < ActiveRecord::Migration[5.2]
  def up
    add_column :journeys, :search_terms, :string
    add_column :steps, :search_terms, :string

    Journey.find_each do |journey|
      journey.save!
    end

    Step.find_each do |step|
      step.save!
    end

    create_index_statement = <<-SQL
      CREATE INDEX journeys_fulltext_idx ON journeys USING GIN (to_tsvector('simple', search_terms));
      CREATE INDEX steps_fulltext_idx ON steps USING GIN (to_tsvector('simple', search_terms));
    SQL

    ActiveRecord::Base.connection.execute(create_index_statement)

    change_column :journeys, :search_terms, :string, null: false
    change_column :steps, :search_terms, :string, null: false
  end

  def down
    remove_column :journeys, :search_terms
    remove_column :steps, :search_terms
  end
end
