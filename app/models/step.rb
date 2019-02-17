class Step < ApplicationRecord
  include Searchable

  belongs_to :journey
  has_many :tasks, dependent: :destroy

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

  searchable :search_terms, [:title, :keywords, :description]
  def to_param
    slug
  end

  def next_step
    journey.steps.where('position > ?', position).order(position: :asc).first
  end
end
