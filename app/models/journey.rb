class Journey < ApplicationRecord
  include Enums
  include Searchable

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

  searchable :search_terms, [:title, :keywords, :description]

  def to_param
    slug
  end
end
