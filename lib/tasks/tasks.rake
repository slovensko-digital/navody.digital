namespace :navody do
  desc "Purge old submission data"
  task cleanup: :environment do
    Submission.expired.destroy_all
  end
end
