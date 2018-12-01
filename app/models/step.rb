class Step < ApplicationRecord
  belongs_to :journey
  has_many :tasks

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :is_waiting_step, inclusion: { in: [true, false] }

  default_scope do
    order(position: :asc)
  end

  before_save :generate_search_terms

  private

  def generate_search_terms
    self.search_terms = "#{Transliterator.transliterate(title&.downcase)} #{Transliterator.transliterate(keywords&.downcase)}".strip
  end
end
