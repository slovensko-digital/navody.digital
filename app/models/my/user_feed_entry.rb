class My::UserFeedEntry < ApplicationRecord
  belongs_to :user
  belongs_to :thing, class_name: 'My::Thing', foreign_key: :my_thing_id
  belongs_to :journey

  scope :pending, -> { where(status: :pending) }
  scope :recently_done, -> { where(status: :done).where('updated_at > ?', 1.month.ago) }

  def done?
    status == 'done'
  end
end
