class Page < ApplicationRecord
  include Searchable
  default_scope { order(position: :asc) }
  scope :faq, -> { where(is_faq: true) }

  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :is_faq, inclusion: { in: [true, false] }

  # FIXME: fill in position from id!

  multisearchable against: %i(title_search keywords_search content_search),
                  if: :is_faq?

  def to_param
    slug
  end

  private

  def title_search
    to_search_str title
  end

  def content_search
    to_search_str content
  end

  def keywords_search
    to_search_str keywords
  end
end
