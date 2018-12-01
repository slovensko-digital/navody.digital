class Task < ApplicationRecord
  belongs_to :step

  default_scope do
    order(position: :asc)
  end
end
