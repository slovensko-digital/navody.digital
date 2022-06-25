class Page < ApplicationRecord
  include Searchable

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :faq, -> { where(is_faq: true) }

  has_and_belongs_to_many :categories

  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :is_faq, inclusion: { in: [true, false] }

  # FIXME: fill in position from id!

  multisearchable against: %i(content_search),
                  if: :searchable?,
                  additional_attributes: -> (page) {
                    { title: page.title_search,
                      keywords: page.keywords_search }
                  }

  def searchable?
    is_faq? || is_searchable?
  end

  def to_param
    slug
  end

  def title_search
    to_search_str title
  end

  def content_search
    to_search_str content
  end

  def keywords_search
    to_search_str keywords
  end

  def should_generate_new_friendly_id?
    slug.blank? && !title.blank?
  end
end
