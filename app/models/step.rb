class Step < ApplicationRecord
  has_many :tasks
  belongs_to :journey

  # FIXME: fill in position from id!

  default_scope do
    order(position: :asc)
  end

  before_save :generate_search_terms

  private

  def generate_search_terms
    self.search_terms = "#{Transliterator.transliterate(title&.downcase)} #{Transliterator.transliterate(keywords&.downcase)}".strip
  end
end
