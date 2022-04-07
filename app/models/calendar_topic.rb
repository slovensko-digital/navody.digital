class CalendarTopic < ApplicationRecord

  validates :name, presence: true

  has_many :calendar_notifications, dependent: :destroy

end
