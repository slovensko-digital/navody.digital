class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:email].present?
      user = User.find_or_create_by!(email: params[:email])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Vitajte!'
    else
      redirect_to log_in_path, alert: 'Prosím zadajte email'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Boli ste úspešne odhlásený.'
  end
end
