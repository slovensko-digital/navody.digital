class CreateJourneyLegalDefinitions < ActiveRecord::Migration[6.1]
  def change
    create_table :laws do |t|
      t.string :identifier, unique: true

      t.timestamps
    end

    create_table :law_versions do |t|
      t.references :law, null: false, foreign_key: true
      t.string :identifier, unique: true
      t.date :valid_from, null: false
      t.date :valid_to
      t.string :checksum

      t.timestamps
    end

    create_table :journey_legal_definitions do |t|
      t.references :journey, null: false, foreign_key: true
      t.references :law, null: false, foreign_key: true
      t.string :link
      t.text :note

      t.timestamps
    end
  end
end
