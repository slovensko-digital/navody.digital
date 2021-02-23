class SendEmailFromTemplateJob < ApplicationJob
  queue_as :default

  #TODO zvazit od zaciatku strukturovat data do takejto podoby
  def perform(email_data)
    params = {
      template_id: email_data.fetch(:template_id),
      to: [
        {
          name: email_data.fetch(:recipient_name),
          email: email_data.fetch(:email)
        }
      ],
      params: email_data.fetch(:template_params),
      attachment: [
        {
          name: email_data.fetch[:attachment_filename],
          content: email_data.fetch(:attachment_content)
        }
      ],
      tags: [
        EmailService::TEMPLATES[template_id],
        *email_data[:tags]
      ].compact
    }

    EmailService.send_email(params)
  end
end
