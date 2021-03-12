class ApplicationController < ActionController::Base
  before_action :set_default_metadata, :set_active_current_topic

  protected

  def current_user
    if session[:user_id]
      @__current_user ||= User.find_by(id: session[:user_id])
    else
      AnonymousUser.new
    end
  end

  helper_method :current_user

  def log_out
    reset_session
    @__current_user = nil
  end

  def require_user
    unless current_user.logged_in?
      redirect_to new_session_path
    end
  end

  def load_newest_user_journey(user, journey)
    @user_step_by_steps = {}
    @user_task_by_tasks = {}
    if user.logged_in?
      @user_journey = UserJourney.order(id: :desc).find_by(user: user, journey: journey)
      if @user_journey
        @user_step_by_steps = @user_journey.user_steps.includes(:step).index_by { |user_step| user_step.step }
        @user_task_by_tasks = @user_journey.user_tasks.includes(:task).index_by { |user_task| user_task.task }
      end
    end
  end

  def disable_feedback
    @disable_feedback = true
  end

  private

  def set_default_metadata
    @metadata = OpenStruct.new(
      og: OpenStruct.new(
        title: nil,
        description: nil,
        image: 'og-navody.png'
      )
    )
  end

  def set_active_current_topic
    active_current_topic = CurrentTopic.active
    return if active_current_topic.blank? || cookies[:current_topic] == active_current_topic.key
    @active_current_topic = active_current_topic
  end

  def log_error(*args)
    Rollbar.error(*args)
  end
end
