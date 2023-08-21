namespace :navody do
  desc "Purge old submission data"
  task cleanup: :environment do
    Submission.expired.destroy_all
    Upvs::Submission.expired.destroy_all
  end

  task check_or_sr_identifiers_status: :environment do
    EmailMeOrSrIdentifiersStatusEmailJob.perform_later
  end

  task schedule_law_check_job: :environment do
    Legal::ScheduleLawCheckJob.perform_later
  end

  task report_quarter_hourly: :environment do
    Environment.stats_reporter.report_quarter_hourly
  end
end
