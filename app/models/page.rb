class Page < ApplicationRecord
  default_scope do
    order(position: :asc)
  end
end
