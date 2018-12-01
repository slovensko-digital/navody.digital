class ApplicationController < ActionController::Base

  protected

  def current_user
    if session[:user_id]
      @__current_user ||= User.find_by(id: session[:user_id])
    end
  end
  helper_method :current_user

end
