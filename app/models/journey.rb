class Journey < ApplicationRecord
  include Enums
  include Searchable

  before_save :update_steps_search

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

  multisearchable against: %i(description_search),
                  if: :published?,
                  additional_attributes: -> (journey) {
                    { title: journey.title_search,
                      keywords: journey.keywords_search }
                  }

  def published?
    published_status == 'PUBLISHED'
  end

  def to_param
    slug
  end

  def description_search
    join_search([html_to_search_str(description), steps_search(:content)])
  end

  def title_search
    join_search([to_search_str(title), steps_search(:title)])
  end

  def keywords_search
    join_search([to_search_str(keywords), steps_search(:keywords)])
  end

  private

  def update_steps_search
    if saved_change_to_published_status?
      steps.each { |s| s.update_pg_search_document }
    end
  end

  def join_search(arr)
    arr.delete_if{ |i| i.blank? }.join(' ')
  end

  def steps_search(column)
    PgSearch::Document.where(searchable: steps).pluck(column).join(' ')
  end
end
