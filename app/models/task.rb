class Task < ApplicationRecord
  self.inheritance_column = 'type2' # TODO: remove this when all STI types are defined

  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true

  default_scope do
    order(position: :asc, id: :asc)
  end
end
