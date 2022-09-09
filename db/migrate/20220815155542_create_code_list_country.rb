class CreateCodeListCountry < ActiveRecord::Migration[6.1]
  def change
    create_table 'code_list.countries' do |t|
      t.integer :identifier
      t.string :value

      t.timestamps
    end
  end
end
