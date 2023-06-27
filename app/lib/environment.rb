module Environment
  extend self

  def stats_reporter
    @stats_reporter ||= StatsReporter.new(
      aws_cloudwatch_client,
      Rails.env
    )
  end

  # INFRASTRUCTURE AWS OBJECTS
  def aws_cloudwatch_client
    @aws_cloudwatch_client ||= build_aws_cloudwatch_client
  end

  def aws_credentials
    @aws_credentials ||= Aws::Credentials.new(
      ENV.fetch('AWS_ACCESS_KEY_ID'),
      ENV.fetch('AWS_SECRET_ACCESS_KEY')
    )
  end

  def aws_region
    @aws_region ||= ENV.fetch('AWS_REGION')
  end

  private
  def build_aws_cloudwatch_client
    Aws::CloudWatch::Client.new(
      credentials: aws_credentials,
      region: aws_region
    )
  end

end
