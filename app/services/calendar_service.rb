class CalendarService
    def self.generate_user_calendar(user)
        calendar_entries = user.calendar_entries

        cal = Icalendar::Calendar.new

        calendar_entries.each do |entry|
            cal.event do |e|
                e.dtstart     = entry.event_date
                e.dtend       = entry.event_date
                e.summary     = entry.calendar_notification.name
                e.description = entry.description
                e.ip_class    = "PRIVATE"
            end
        end

        cal.publish
        cal
    end
end