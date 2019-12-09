class PgSearch::Document < ::ActiveRecord::Base
  include Searchable
  self.table_name = 'pg_search_documents'
  belongs_to :searchable, polymorphic: true

  scope :featureable, -> { where(searchable_type: ['Journey', 'App']) }
  scope :featured, -> { featureable.where(featured: true) }

  def self.reposition_all
    Document.featured.each.with_index(1) do |document, index|
      document.update!(position: index)
    end
  end

  pg_search_scope :search, against: {
    keywords: 'A',
    title: 'A',
    content: 'D',
  }, using: {
    tsearch: {
      any_word: true,
      prefix: false,
      normalization: 0,
    },
  }
end
