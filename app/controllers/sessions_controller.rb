class SessionsController < ApplicationController
  before_action :disable_feedback

  def new
    session[:after_login_callback] = params[:callback]
  end

  def create
    if should_put_eid_token_in_session?
      session[:eid_encoded_token] = eid_encoded_token_from_auth
    end

    if new_eid_identity?
      render :new_eid_identity, locals: { eid_token: eid_token }
      return
    end

    unless auth_email.present?
      redirect_to new_session_path, alert: 'Prosím zadajte e-mail'
      return
    end

    user = User.find_by('lower(email) = lower(?)', auth_email) || User.create!(email: auth_email)

    notice = user.previously_new_record? ? :first_time_login : 'Prihlásenie úspešné. Vitajte!'

    if eid_identity_approval?
      user.update!(eid_sub: eid_sub_from_auth)
    end

    unless should_keep_eid_token_in_session?(user.eid_sub)
      session.delete(:eid_encoded_token)
    end

    session[:user_id] = user.id

    redirect_to after_login_redirect_path, notice: notice
  end
  def magic_link_info
    @email = params[:email]
  end

  def failure
    @message = params[:message]
    @strategy = params[:strategy]
  end

  def logout
    reset_session

    if params[:callback].present?
      redirect_to params[:callback]
    else
      redirect_to root_path, notice: 'Odhlásenie bolo úspešné.'
    end
  end

  def destroy
    if should_perform_eid_logout?
      redirect_to eid_token.generate_logout_url(expires_in: 5.minutes)
    else
      logout
    end
  end

  protected

  def auth_email
    auth_hash.dig('info', 'email')
  end

  private

  def should_perform_eid_logout?
    eid_token.present? && !eid_token.expired?
  end

  def new_eid_identity?
    auth_hash.provider == "eid" && auth_hash.info['email'].blank?
  end

  def eid_identity_approval?
    auth_hash.provider == "magiclink" && eid_sub_from_auth.present?
  end

  def should_keep_eid_token_in_session?(user_eid_sub)
    eid_encoded_token_from_session.present? && EidToken.new(eid_encoded_token_from_session, config: eid_config).sub == user_eid_sub
  end

  def should_put_eid_token_in_session?
    auth_hash.provider == "eid" && eid_encoded_token_from_auth.present?
  end

  def after_login_redirect_path
    return session[:after_login_callback] if session[:after_login_callback]&.start_with?("/") # Only allow local redirects
    root_path
  end
end
