class Page < ApplicationRecord
  include Searchable
  default_scope { order(position: :asc) }
  scope :faq, -> { where(is_faq: true) }

  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :is_faq, inclusion: { in: [true, false] }

  # FIXME: fill in position from id!

  searchable :search_terms, [:title, :content, :keywords]

  def to_param
    slug
  end
end
