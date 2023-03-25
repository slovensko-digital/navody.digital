class EmailMeSubmissionInstructionsEmailJob < ApplicationJob
  queue_as :default

  def perform(submission)
    email = build_template_email(submission)
    Submission.transaction do
      submission.expires_at = Submission.expiration_time
      submission.save!
      EmailService.send_email(email)
    end
  end

  private

  def build_template_email(submission)
    extra = submission.extra
    {
      templateId: Integer(extra['template_id']),
      params: extra['params'],
      to: [{ email: submission.user_email }],
      attachment: submission.attachments.map do |attachment|
        {
          name: attachment['filename'],
          content: attachment['body_base64'],
        }
      end
    }
  end
end
