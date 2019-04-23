module MailerSupport
  def link_in_last_email
    mailer_email = ActionMailer::Base.deliveries.last
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    email.find('a')[:href]
  end

  def clear_mail_deliveries
    ActionMailer::Base.deliveries = []
  end
end
