class ReportQuarterHourlyJob < ApplicationJob
  queue_as :default

  def perform
    Environment.stats_reporter.report_quarter_hourly
  end
end
