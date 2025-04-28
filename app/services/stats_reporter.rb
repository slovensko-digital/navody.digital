class StatsReporter
  def initialize(cloudwatch_client, environment)
    @client = cloudwatch_client
    @environment = environment
  end

  def report_quarter_hourly
    report_metric('JobsCount', GoodJob::Job.count - GoodJob::Job.succeeded.count)
    report_metric('FailedJobsCount', GoodJob::Job.where.not(error: nil).count)
    report_metric('StuckJobsCount', GoodJob::Job.where(finished_at: nil).where("COALESCE(scheduled_at, created_at) < ?", 1.hour.ago).count)
  end

  private
  def report_metric(name, value)
    @client.put_metric_data(
      namespace: 'NavodyDigital',
      metric_data: [
        {
          metric_name: name,
          dimensions: [{ name: 'Environment', value: @environment }],
          timestamp: Time.current.utc,
          value: value,
        }
      ]
    )
  end
end
