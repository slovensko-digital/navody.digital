class CreateCodeListMunicipality < ActiveRecord::Migration[6.1]
  def change
    create_table 'code_list.municipalities' do |t|
      t.integer :identifier
      t.string :value

      t.timestamps
    end
  end
end
