class UserMailer < ApplicationMailer
  def magic_link
    @email = params[:email]
    @token = params[:token]
    @magic_link = auth_callback_url(:magiclink, token: @token)

    mail to: @email, subject: 'Návody.Digital: Odkaz na prihlásenie'
  end
end
