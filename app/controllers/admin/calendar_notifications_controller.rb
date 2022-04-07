class Admin::CalendarNotificationsController < Admin::AdminController
  def index
    @calendar_notifications = CalendarNotification.all
  end

  def new
    @calendar_notification = CalendarNotification.new
    @calendar_topics = CalendarTopic.all
  end

  def edit
    @calendar_notification = CalendarNotification.find_by!(id: params[:id])
    @calendar_topics = CalendarTopic.all
  end

  def create
    @calendar_notification = CalendarNotification.new(calendar_notification_params)
    @calendar_notification.save!
    redirect_to admin_calendar_notifications_url
  end

  def destroy
    @calendar_notification = CalendarNotification.find_by!(id: params[:id])
    @calendar_notification.destroy
    redirect_to admin_calendar_notifications_url, notice: 'Calendar notification was successfully destroyed.'
  end

  def update
    @calendar_notification = CalendarNotification.find_by!(id: params[:id])
    if @calendar_notification.update(calendar_notification_params)
      redirect_to admin_calendar_notifications_url, notice: 'Calendar notification was successfully updated.'
    else
      render :edit
    end
  end

  private def calendar_notification_params
    params.require(:calendar_notification).permit(:name, :calendar_topic_id, :type)
  end
end
