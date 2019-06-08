class QuickTip < ApplicationRecord
  belongs_to :journey, optional: true
  belongs_to :step, optional: true

  def to_param
    slug
  end
end
