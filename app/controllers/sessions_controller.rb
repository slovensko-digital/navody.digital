class SessionsController < ApplicationController
  before_action :disable_feedback

  def new
    session[:after_login_callback] = params[:callback]
  end

  def create
    if new_eid_identity?
      session[:eid_uid] = auth_hash.uid
      redirect_to new_eid_onboarding_path
      return
    end

    redirect_to new_session_path, alert: 'Prosím zadajte e-mail' and return unless auth_email.present?

    user = User.find_by('lower(email) = lower(?)', auth_email) || User.create!(email: auth_email)

    if eid_identity_approval?
      user.update!(eid_sub: auth_hash.info['eid_uid'])
      session.delete(:eid_uid)
    end

    if eid_token_sub_mismatch?(user.eid_sub)
      session.delete(:eid_encoded_token)
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

    if params[:callback].present?
      redirect_to params[:callback]
    else
      redirect_to root_path, notice: 'Odhlásenie bolo úspešné.'
    end
  end

  def destroy
    if should_perform_eid_logout?
      eid_config = Rails.application.config_for(:auth)[:eid]

      logout_url = "#{eid_config[:base_url]}/logout"
      private_key = OpenSSL::PKey::RSA.new(eid_config[:private_key])
      logout_token = JWT.encode({
                                  exp: (Time.zone.now + 5.minutes).to_i,
                                  jti: SecureRandom.uuid,
                                  obo: session[:eid_encoded_token],
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

  def should_perform_eid_logout?
    eid_token.present? && !eid_token.expired?
  end

  def new_eid_identity?
    auth_hash.provider == "eid" && auth_hash.info['email'].blank?
  end

  def eid_identity_approval?
    auth_hash.provider == "magiclink" && auth_hash.info['eid_uid'].present?
  end

  def eid_token_sub_mismatch?(user_eid_sub)
    session[:eid_encoded_token].present? && eid_token.sub != user_eid_sub
  end

  def eid_token
    EidToken.new(session[:eid_encoded_token], public_key: Rails.application.config_for(:auth).dig(:eid, :public_key))
  end

  def after_login_redirect_path
    return session[:after_login_callback] if session[:after_login_callback]&.start_with?("/") # Only allow local redirects
    root_path
  end
end
