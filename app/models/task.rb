class Task < ApplicationRecord
  before_save :normalize_blank_attributes

  self.inheritance_column = nil
  TYPES = %w[SimpleTask ExternalLinkTask]

  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true, inclusion: Task::TYPES
  validates :url, url: true, if: -> { type == 'ExternalLinkTask' }
  validates :url_title, presence: true, allow_nil: true

  default_scope do
    order(position: :asc, id: :asc)
  end
end
