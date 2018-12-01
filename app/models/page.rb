class Page < ApplicationRecord
  default_scope { order(position: :asc) }
  scope :faq, -> { where(is_faq: true) }

  # FIXME: fill in position from id!

  def to_param
    slug
  end
end
