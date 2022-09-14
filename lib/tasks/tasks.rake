namespace :navody do
  desc "Purge old submission data"
  task cleanup: :environment do
    Submission.expired.destroy_all
  end

  task check_or_sr_identifiers_status: :environment do
    EmailMeOrSrIdentifiersStatusEmailJob.perform_later
  end
end
