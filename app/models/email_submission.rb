class EmailSubmission < Submission
  attr_accessor :recipient_name, :recipient_email, :template_id

  attr_writer :template_options

  validates :template_id, presence: true
  # validates :template_id, numericality: true

  # TODO refactor
  def submit
    ::SendEmailFromTemplateJob.perform_later(self.as_json)
  end
end