class CalendarSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :calendar_notification
end
