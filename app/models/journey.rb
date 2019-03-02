class Journey < ApplicationRecord
  include Enums
  include PgSearch

  after_save :update_steps

  default_scope { order(position: :asc) }

  scope :published, -> { where(published_status: 'PUBLISHED')}

  has_many :steps, dependent: :destroy
  has_many :tasks, through: :steps
  has_many :user_journeys

  enumerates :published_status, with: %w{DRAFT PUBLISHED}

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  # FIXME: fill in position from id!

  multisearchable against: %i(title_search keywords_search description_search),
                  if: :published?

  def published?
    published_status == 'PUBLISHED'
  end

  def to_param
    slug
  end

  private

  def update_steps
    steps.each { |s| s.save! }
  end

  def title_search
    Transliterator.transliterate(title&.downcase)
  end

  def description_search
    desc = ActionView::Base.full_sanitizer.sanitize(description).gsub("\n", ' ')
    Transliterator.transliterate(desc&.downcase)
  end

  def keywords_search
    Transliterator.transliterate(keywords&.downcase)
  end
end
