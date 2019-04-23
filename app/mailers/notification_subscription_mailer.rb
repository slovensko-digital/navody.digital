class NotificationSubscriptionMailer < ApplicationMailer
  def confirmation_email
    @email = params[:email]
    @token = params[:token]
    @types = params[:types]

    mail to: @email, subject: 'Návody.Digital: Potvrdenie odberu notifikácií'
  end
end
