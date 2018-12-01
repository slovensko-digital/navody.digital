class Journey < ApplicationRecord
  has_many :steps

  default_scope do
    order(position: :asc)
  end

  before_save :generate_search_terms

  private

  def generate_search_terms
    self.search_terms = Settings.stemmer.call("#{Transliterator.transliterate(title&.downcase)} #{Transliterator.transliterate(keywords&.downcase)}".strip)
  end
end
