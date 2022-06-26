class Category < ApplicationRecord
    scope :featured, -> { where(featured: true) }
end
