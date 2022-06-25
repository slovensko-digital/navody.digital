class App < ApplicationRecord
  include Enums
  include Searchable

  extend FriendlyId
  friendly_id :title, use: :slugged

  scope :published, -> { where(published_status: 'PUBLISHED')}

  has_many :search_documents, :class_name => 'Document', as: :searchable

  has_and_belongs_to_many :categories

  enumerates :published_status, with: %w{DRAFT PUBLISHED}

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  multisearchable against: %i(description_search),
    if: :published?,
    additional_attributes: -> (app) {
      { title: app.title_search,
        published: app.published?}
    }

  def published?
    published_status == 'PUBLISHED'
  end

  def to_param
    slug
  end

  def title_search
    join_search([to_search_str(title)])
  end

  def description_search
    join_search([html_to_search_str(description)])
  end

  def should_generate_new_friendly_id?
    slug.blank? && !title.blank?
  end

  private

  def join_search(arr)
    arr.delete_if{ |i| i.blank? }.join(' ')
  end
end
