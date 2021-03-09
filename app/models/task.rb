class Task < ApplicationRecord
  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true

  default_scope do
    order(position: :asc, id: :asc)
  end
end

require_dependency "simple_task"
require_dependency "external_link_task"