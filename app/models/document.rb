class Document < ::PgSearch::Document
  include Searchable

  scope :featureable, -> { where(searchable_type: ['Journey', 'App', 'Page']) }
  scope :featured, -> { featureable.where(featured: true) }

  scope :join_on_category_id, -> (category_id) {
    joins('INNER JOIN categorizations ON categorizations.categorizable_id = searchable_id AND categorizations.categorizable_type = searchable_type')
    .joins('INNER JOIN categories_categorizations ON categories_categorizations.categorization_id = categorizations.id')
    .joins('INNER JOIN categories ON categories.id = categories_categorizations.category_id')
    .where('categories.id = ?', category_id)
  }

  def self.reposition_all
    featured.order(featured_position: :asc).each.with_index(1) do |document, index|
      document.update!(featured_position: index)
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
