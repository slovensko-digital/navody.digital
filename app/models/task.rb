class Task < ApplicationRecord
  belongs_to :step

  # FIXME: fill in position from id!

  default_scope do
    order(position: :asc)
  end
end
