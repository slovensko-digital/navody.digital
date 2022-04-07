class Admin::CalendarTopicsController < Admin::AdminController
  def index
    @calendar_topics = CalendarTopic.all
  end

  def new
    @calendar_topic = CalendarTopic.new
  end

  def edit
    @calendar_topic = CalendarTopic.find_by!(id: params[:id])
  end

  def create
    @calendar_topic = CalendarTopic.new(calendar_topic_params)
    @calendar_topic.save!
    redirect_to admin_calendar_topics_url
  end

  def destroy
    @calendar_topic = CalendarTopic.find_by!(id: params[:id])
    @calendar_topic.destroy
    redirect_to admin_calendar_topics_url, notice: 'Calendar topic was successfully destroyed.'
  end

  def update
    @calendar_topic = CalendarTopic.find_by!(id: params[:id])
    if @calendar_topic.update(calendar_topic_params)
      redirect_to admin_calendar_topics_url, notice: 'Calendar topic was successfully updated.'
    else
      render :edit
    end
  end

  private def calendar_topic_params
    params.require(:calendar_topic).permit(:name)
  end
end
