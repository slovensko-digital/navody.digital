class Task < ApplicationRecord
  self.inheritance_column = nil
  TYPES = %w[SimpleTask ExternalLinkTask]

  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true, inclusion: Task::TYPES

  validates :url, url: true, if: :external_link_task?
  validates :url_title, presence: true, if: :external_link_task?

  default_scope do
    order(position: :asc, id: :asc)
  end

  private

  def external_link_task?
    type == 'ExternalLinkTask'
  end
end
