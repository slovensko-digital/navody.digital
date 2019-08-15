class AddPositionToPgSearchDocument < ActiveRecord::Migration[5.2]
  def change
    add_column :pg_search_documents, :position, :integer, default: 0
    add_column :pg_search_documents, :published, :boolean, default: false

    Journey.includes(:search_documents).find_each do |journey|
      journey.search_documents.each do |document|
        document.update_attributes({position: journey.position, published: journey.published?})
      end
    end

    remove_column :journeys, :position
  end
end
