class Journey < ApplicationRecord
  include Enums
  include Searchable

  after_save :update_steps_search

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

  def update_steps_search
    if saved_change_to_published_status?
      steps.each { |s| s.update_pg_search_document }
    end
  end

  def title_search
    to_search_str title
  end

  def description_search
    html_to_search_str description
  end

  def keywords_search
    to_search_str keywords
  end
end
