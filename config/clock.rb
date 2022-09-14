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
  every(1.day, 'navody:check_or_sr_identifiers_status', at: '9:00')
  every(20.minutes, 'navody:cleanup')
end
