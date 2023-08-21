class StatsReporter
  def initialize(cloudwatch_client, environment)
    @client = cloudwatch_client
    @environment = environment
  end

  def report_quarter_hourly
    report_metric('JobsCount', Que::ActiveRecord::Model.count)
    report_metric('FailedJobsCount', Que::ActiveRecord::Model.errored.count)
    report_metric('StuckJobsCount', Que::ActiveRecord::Model.where('run_at < ?', 1.hour.ago).count)
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
