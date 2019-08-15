class PgSearch::Document < ::ActiveRecord::Base
  include Searchable
  self.table_name = 'pg_search_documents'
  belongs_to :searchable, polymorphic: true

  default_scope { order(position: :asc) }

  scope :featured_on_front_page, -> { where(searchable_type: ['Journey', 'App']).where(published: true)}

  pg_search_scope :search, against: {
    keywords: 'A',
    title: 'A',
    content: 'D',
  }, using: {
    tsearch: {
      any_word: true,
      prefix: false,
      normalization: 1,
    },
  }
end
