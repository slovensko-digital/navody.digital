class Step < ApplicationRecord
  has_many :tasks
  belongs_to :journey
end
