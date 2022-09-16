class CreateCodeListCourt < ActiveRecord::Migration[6.1]
  def change
    create_table 'code_list.courts' do |t|
      t.string :name
      t.string :street
      t.string :number
      t.string :postal_code
      t.string :municipality
      t.integer :identifier
      t.string :code

      t.timestamps
    end
  end
end
