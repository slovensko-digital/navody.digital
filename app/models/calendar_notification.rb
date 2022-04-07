class CalendarNotification < ApplicationRecord

  belongs_to :calendar_topic
  belongs_to :step, optional: true
  has_many :calendar_subscriptions, dependent: :destroy
  has_many :calendar_entries, dependent: :destroy

  validates :name, presence: true

end
