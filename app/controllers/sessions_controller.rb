class SessionsController < ApplicationController
  before_action :disable_feedback

  def new
    session[:after_login_callback] = params[:callback]
  end

  def create
    if auth_hash.provider == "eid" && auth_hash.info['email'].blank?
      session[:eid_uid] = auth_hash.uid
      redirect_to new_eid_onboarding_path
      return
    end

    redirect_to new_session_path, alert: 'Prosím zadajte e-mail' and return unless auth_email.present?

    user = User.find_by('lower(email) = lower(?)', auth_email) || User.create!(email: auth_email)

    if auth_hash.info['eid_uid'].present?
      user.update!(eid_sub: auth_hash.info['eid_uid'])
      session.delete(:eid_uid)
    end

    session[:user_id] = user.id
    redirect_to after_login_redirect_path, notice: 'Prihlásenie úspešné. Vitajte!'
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

    redirect_to root_path, notice: 'Odhlásenie bolo úspešné.'
  end

  def destroy
    eid_encoded_token = session[:eid_encoded_token]
    eid_token_expires_at = session[:eid_token_expires_at].present? ? Time.zone.parse(session[:eid_token_expires_at]) : nil

    if eid_encoded_token.present? && eid_token_expires_at&.future?
      eid_config = Rails.application.config_for(:auth)[:eid]

      eid_encoded_token = eid_encoded_token
      logout_url = "#{eid_config[:base_url]}/logout"
      private_key = OpenSSL::PKey::RSA.new(eid_config[:private_key])
      logout_token = JWT.encode({
                                  "exp": (Time.zone.now + 5.minutes).to_i,
                                  "jti": SecureRandom.uuid,
                                  "obo": eid_encoded_token,
                                }, private_key, 'RS256', { cty: 'JWT' })

      redirect_to "#{logout_url}?token=#{logout_token}"
    else
      logout
    end
  end

  protected

  def auth_email
    auth_hash.dig('info', 'email')
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  private

  def after_login_redirect_path
    return session[:after_login_callback] if session[:after_login_callback]&.start_with?("/") # Only allow local redirects
    root_path
  end
end
