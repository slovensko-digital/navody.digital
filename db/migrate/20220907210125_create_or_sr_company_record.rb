class CreateOrSrCompanyRecord < ActiveRecord::Migration[6.1]
  def change
    create_table :or_sr_company_records do |t|
      t.bigint :cin
      t.boolean :identifiers_ok, default: false
      t.string :email

      t.timestamps
    end
  end
end
