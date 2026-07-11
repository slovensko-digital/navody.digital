class CleanupJob < ApplicationJob
  queue_as :default

  def perform
    Submission.expired.destroy_all
    Upvs::Submission.expired.destroy_all
  end
end
