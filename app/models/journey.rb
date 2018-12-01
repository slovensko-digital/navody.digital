class Journey < ApplicationRecord
  has_many :steps

  default_scope do
    order(position: :asc)
  end
end
