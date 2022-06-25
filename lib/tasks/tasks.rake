namespace :navody do
  desc "Purge old submission data"
  task cleanup: :environment do
    Submission.expired.destroy_all
  end

  desc "Run user feed entry generators"
  task 'userfeeds:generate': :environment do
    My::FeedEntryGenerator.each do |generator|
      generator.run
    end
  end
end
