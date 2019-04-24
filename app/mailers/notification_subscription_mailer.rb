class NotificationSubscriptionMailer < ApplicationMailer
  def confirmation_email
    @email = params[:email]
    @token = params[:token]

    mail to: @email, subject: 'Návody.Digital: Potvrdenie zasielania notifikácií'
  end
end
