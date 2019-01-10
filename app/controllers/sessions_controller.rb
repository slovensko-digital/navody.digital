class SessionsController < ApplicationController
  def new
  end

  def create
    if auth_email.present?
      user = User.find_or_create_by!(email: auth_email)
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Vitajte!'
    else
      redirect_to new_session_path, alert: 'Prosím zadajte email'
    end
  end

  def magic_link_info
    @email = params[:email]
  end

  def failure
    @message = params[:message]
    @strategy = params[:strategy]
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path, notice: 'Boli ste úspešne odhlásený.'
  end

  protected

  def auth_email
    auth_hash.dig('info', 'email')
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
