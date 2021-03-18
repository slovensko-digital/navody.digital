class DestroySubmissionJob < ApplicationJob
  queue_as :default

  def perform(submission)
    submission.destroy
  end
end
