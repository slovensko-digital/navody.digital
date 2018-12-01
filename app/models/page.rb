class Page < ApplicationRecord
  default_scope { order(position: :asc) }
  scope :faq, -> { where(is_faq: true) }
end
