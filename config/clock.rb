require_relative 'environment'

Rails.application.load_tasks

module Clockwork
  configure do |config|
    config[:thread] = true
    config[:tz] = Rails.application.config.time_zone
  end

  handler do |name|
    Rake::Task[name].reenable
    Rake::Task[name].invoke
  end

  every(1.week, 'sitemap:refresh', at: 'Monday 9:00') if Rails.env.production?
  every(1.day, 'navody:userfeeds:generate')
  every(20.minutes, 'navody:cleanup')
end
