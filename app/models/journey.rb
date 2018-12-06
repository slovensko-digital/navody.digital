class Journey < ApplicationRecord
  include Enums

  has_many :steps
  has_many :tasks, through: :steps

  enumerates :published_status, with: %w{DRAFT PUBLISHED}

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  # FIXME: fill in position from id!

  default_scope { order(position: :asc) }

  before_save :generate_search_terms

  def to_param
    slug
  end

  private

  def generate_search_terms
    self.search_terms = "#{Transliterator.transliterate(title&.downcase)} #{Transliterator.transliterate(keywords&.downcase)}".strip
  end
end
