class Task < ApplicationRecord
  self.inheritance_column = 'type2' # TODO: remove this when all STI types are defined

  belongs_to :step

  validates :title, presence: true
  validates :type, presence: true
  validates :url, presence: true
end
