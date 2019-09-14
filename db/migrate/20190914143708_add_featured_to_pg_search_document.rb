class AddFeaturedToPgSearchDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :pg_search_documents, :featured, :boolean, null: false, default: false
    PgSearch::Document.featureable.find_each do |doc|
      if doc.published? && !doc.blank?
        doc.update(featured: true)
      end
    end
  end
end
