class ApplicationController < ActionController::Base

  protected

  def current_user
    if session[:user_id]
      @__current_user ||= User.find_by(id: session[:user_id])
    else
      AnonymousUser.new
    end
  end

  helper_method :current_user

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
end
