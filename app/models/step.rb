class Step < ApplicationRecord
  belongs_to :journey
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :is_waiting_step, inclusion: { in: [true, false] }

  # FIXME: fill in position from id!

  default_scope { order(position: :asc) }

  before_save :generate_search_terms

  def to_param
    slug
  end

  def next_step
    journey.steps.where('position > ?', position).order(position: :asc).first
  end

  private

  def generate_search_terms
    self.search_terms = "#{Transliterator.transliterate(title&.downcase)} #{Transliterator.transliterate(keywords&.downcase)}".strip
  end
end
