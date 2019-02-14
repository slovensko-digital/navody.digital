class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_EMAIL_FROM', 'missing@set.in.env')
  layout 'mailer'
end
