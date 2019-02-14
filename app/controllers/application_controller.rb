class ApplicationController < ActionController::Base

  protected

  def current_user
    if session[:user_id]
      @__current_user ||= User.find_by(id: session[:user_id])
    end
  end

  helper_method :current_user

  def require_user
    unless current_user
      redirect_to new_session_path
    end
  end

  def load_last_unfinished_journey(user, journey)
    if user
      @unfinished_user_journey = UserJourney.order(id: :desc).find_by(user: user, journey: journey)
    end
  end

  def disable_feedback
    @disable_feedback = true
  end
end
