class EmailSubmission < Submission
  attr_accessor :template_id

  attr_writer :template_options

  validates :template_id, presence: true
  # validates :template_id, numericality: true

  def submit
    ::SendEmailFromTemplateJob.perform_later(self.attributes)
  end
end