class Step < ApplicationRecord
  belongs_to :journey
  has_many :tasks

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :is_waiting_step, inclusion: { in: [true, false] }
end
