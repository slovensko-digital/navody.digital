class CalendarController < ApplicationController
  def show
    signed_id = params[:cal_id]
    user = User.find_signed(signed_id, purpose: :calendar)
    unless user
      render plain: 'Neplatná URL adresa', status: :bad_request unless user
      return
    end

    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        event = Icalendar::Event.new
        event.dtstart = Date.today
        event.dtend = Date.today
        event.summary = 'Toto je nadpis'
        event.uid = event.url = "event_url"
        cal.add_event(event)

        cal = Icalendar::Calendar.new
        event = Icalendar::Event.new
        event.dtstart = Date.today + 1.day
        event.dtend = Date.today + 1.day
        event.summary = 'Toto je uplne iny event'
        event.uid = event.url = "uplne_ina_event_url"
        cal.add_event(event)

        cal.publish
        render plain: cal.to_ical
      end
    end
  end
end
