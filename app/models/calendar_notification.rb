class CalendarNotification < ApplicationRecord

  belongs_to :calendar_topic
  belongs_to :step
  has_many :calendar_subscriptions, dependent: :destroy
  has_many :calendar_entries, dependent: :destroy

  validates :name, presence: true

  serialize :dates, Array

end
