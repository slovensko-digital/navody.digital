class CreateUpvsFormTemplateRelatedDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table 'upvs.form_template_related_documents' do |t|
      t.string :posp_id, null: false
      t.string :posp_version, null: false
      t.string :message_type, null: false
      t.text :xsd_schema, limit: 16.megabytes - 1
      t.text :xslt_transformation, limit: 16.megabytes - 1

      t.timestamps
    end
  end
end
