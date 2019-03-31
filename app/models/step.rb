class Step < ApplicationRecord
  include Searchable

  belongs_to :journey
  has_many :tasks, dependent: :destroy


  after_commit :update_journey_search

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :is_waiting_step, inclusion: { in: [true, false] }

  # FIXME: fill in position from id!

  default_scope { order(position: :asc) }
  scope :published, -> do
    joins(:journey)
      .where(journeys: { published_status: 'PUBLISHED' })
  end

  multisearchable against: %i(description_search),
                  if: :published?,
                  additional_attributes: -> (step) {
                    { title: step.title_search,
                      keywords: step.keywords_search }
                  }

  def published?
    journey.published_status == 'PUBLISHED'
  end

  def to_param
    slug
  end

  def next_step
    journey.steps.where('position > ?', position).order(position: :asc).first
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

  private

  def update_journey_search
    journey.update_pg_search_document
  end
end
