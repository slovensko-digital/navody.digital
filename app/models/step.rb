class Step < ApplicationRecord
  has_many :tasks
  belongs_to :journey

  default_scope do
    order(position: :asc)
  end
end
