class Journey < ApplicationRecord
  include Enums
  include Searchable

  extend FriendlyId
  friendly_id :title, use: :slugged

  before_save :update_steps_search

  scope :published, -> { where(published_status: 'PUBLISHED') }
  scope :blank, -> { where(published_status: 'BLANK') }
  scope :displayable, -> { published.or(blank) }
  scope :url_only, -> { where(published_status: 'URL_ONLY') }
  scope :accessible_by_url, -> { published.or(blank).or(url_only) }

  has_many :steps, dependent: :destroy
  has_many :tasks, through: :steps
  has_many :user_journeys
  has_many :journey_legal_definitions
  has_many :laws, through: :journey_legal_definitions

  enumerates :published_status, with: %w{DRAFT URL_ONLY BLANK PUBLISHED}

  has_many :search_documents, :class_name => 'Document', as: :searchable
  has_one :categorization, :as => :categorizable, dependent: :destroy
  accepts_nested_attributes_for :categorization

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true, unless: :blank?
  validates :short_description, presence: true, unless: :blank?
  # FIXME: fill in position from id!

  multisearchable against: %i(description_search),
                  if: :searchable?,
                  additional_attributes: -> (journey) {
                    { title: journey.title_search,
                      keywords: journey.keywords_search,
                      published: journey.published? }
                  }

  def published?
    published_status == 'PUBLISHED'
  end

  def blank?
    published_status == 'BLANK'
  end

  def searchable?
    published? || blank?
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

  def new_step
    new_position = steps.empty? ? 1 : steps.last.position + 1
    steps.new(position: new_position)
  end

  def reposition
    steps.each_with_index do |step, index|
      step.position = index + 1
      step.save
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? && !title.blank?
  end

  def is_outdated?
    return true if last_checked_on.nil?
    return true if laws.any? {|law| law.active_version.nil?}

    laws.any? {|law| last_checked_on < law.valid_from || last_checked_on < law.active_version.updated_at }
  end

  def updated_laws_since_last_check
    return laws if last_checked_on.nil?

    laws.select {|law| last_checked_on < law.valid_from }
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
    Document.where(searchable: steps).pluck(column).join(' ')
  end
end
