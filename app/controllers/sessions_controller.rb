class SessionsController < ApplicationController
  before_action :disable_feedback

  def new
  end

  def create
    redirect_to new_session_path, alert: 'Prosím zadajte email' and return unless auth_email.present?

    user = User.find_by('lower(email) = lower(?)', auth_email) || User.create!(email: auth_email)

    session[:user_id] = user.id
    redirect_to root_path, notice: 'Prihlásenie úspešné. Vitajte!'
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

    redirect_to root_path, notice: 'Boli ste úspešne odhlásený/á.'
  end

  protected

  def auth_email
    auth_hash.dig('info', 'email')
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
