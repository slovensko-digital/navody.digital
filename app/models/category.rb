class Category < ApplicationRecord
  has_and_belongs_to_many :categorizations

  validates :name, presence: true
  validates :description, presence: true
  validates :featured_position, presence: true

  scope :featured, -> { where(featured: true) }
end
