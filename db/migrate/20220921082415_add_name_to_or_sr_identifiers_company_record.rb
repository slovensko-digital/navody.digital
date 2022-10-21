class AddNameToOrSrIdentifiersCompanyRecord < ActiveRecord::Migration[6.1]
  def change
    add_column :or_sr_company_records, :name, :string
  end
end
