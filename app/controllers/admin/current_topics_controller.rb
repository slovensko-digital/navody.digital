class Admin::CurrentTopicsController < Admin::AdminController
  before_action :set_current_topic, only: [:show, :edit, :update, :destroy]

  def index
    current_topic = CurrentTopic.last
    return redirect_to edit_admin_current_topic_path(current_topic) if current_topic.present?
    redirect_to new_admin_current_topic_path
  end

  def new
    @current_topic = CurrentTopic.new
  end

  def create
    @current_topic = CurrentTopic.new(current_topic_params)
    @current_topic.save!
    redirect_to admin_current_topics_url
  end

  def update
    @current_topic.update!(current_topic_params)
    redirect_to admin_current_topics_url
  end

  private def set_current_topic
    @current_topic = CurrentTopic.find_by!(id: params[:id])
  end

  private def current_topic_params
    params.require(:current_topic).permit(
      :key,
      :value,
      :enabled
    )
  end
end
