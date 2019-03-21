class Step < ApplicationRecord
  include Searchable

  belongs_to :journey
  has_many :tasks, dependent: :destroy
  has_many :user_steps, dependent: :destroy

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

  multisearchable against: %i(title_search keywords_search description_search),
                  if: :published?

  def published?
    journey.published_status == 'PUBLISHED'
  end

  def to_param
    slug
  end

  def next_step
    journey.steps.where('position > ?', position).order(position: :asc).first
  end

  private

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
