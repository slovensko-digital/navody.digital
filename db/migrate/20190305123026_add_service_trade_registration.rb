class AddServiceTradeRegistration < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_registrations do |t|
      # t.belongs_to :user_step, null: false

      t.text :progress_step

      t.text :first_name
      t.text :last_name
      t.text :birth_code

      t.text :street_name
      t.text :street_number
      t.text :city
      t.integer :postcode

      t.text :place_of_birth
      t.text :father_first_name
      t.text :father_last_name
      t.text :mother_first_name
      t.text :mother_last_name
      t.text :mother_maiden_name

      t.timestamps
    end
  end
end
