class Page < ApplicationRecord
  include Searchable

  has_one :categorization, :as => :categorizable, dependent: :destroy
  accepts_nested_attributes_for :categorization

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :faq, -> { where(is_faq: true) }
  scope :searchable, -> { where(is_searchable: true) }

  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :is_faq, inclusion: { in: [true, false] }
  validates :short_description, presence: true, if: :is_searchable?

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
