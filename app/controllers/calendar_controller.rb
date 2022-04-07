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
        calendar = CalendarService.generate_user_calendar(user)
        render plain: calendar.to_ical
      end
    end
  end
end
