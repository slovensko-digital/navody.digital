module MailerSupport
  def link_in_last_email
    mailer_email = ActionMailer::Base.deliveries.last
    email = Capybara::Node::Simple.new(mailer_email.parts.find { |part| part.content_type == 'text/html; charset=UTF-8' }.body.to_s)
    email.find('.yield a', match: :first)[:href]
  end

  def clear_mail_deliveries
    ActionMailer::Base.deliveries = []
  end
end
