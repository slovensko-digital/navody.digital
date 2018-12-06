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
end
