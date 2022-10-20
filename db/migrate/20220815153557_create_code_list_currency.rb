class CreateCodeListCurrency < ActiveRecord::Migration[6.1]
  def change
    create_table 'code_list.currencies' do |t|
      t.integer :identifier
      t.string :value
      t.string :code

      t.timestamps
    end
  end
end
