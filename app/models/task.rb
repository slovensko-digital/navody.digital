class Task < ApplicationRecord
  self.inheritance_column = nil
  TYPES = %w[SimpleTask ExternalLinkTask]

  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true, inclusion: Task::TYPES
  validates :url, url: true, if: -> { type == 'ExternalLinkTask' }

  default_scope do
    order(position: :asc, id: :asc)
  end
end
