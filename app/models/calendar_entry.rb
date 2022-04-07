class CalendarEntry < ApplicationRecord
  belongs_to :calendar_notification
  belongs_to :user

  validates :event_date, :notification_date, presence: true
end
