class Categorization < ApplicationRecord
  belongs_to :categorizable, :polymorphic => true
  has_and_belongs_to_many :categories
end
