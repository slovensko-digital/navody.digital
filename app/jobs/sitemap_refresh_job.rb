class SitemapRefreshJob < ApplicationJob
  queue_as :default

  def perform
    return unless Rails.env.production?

    SitemapGenerator::Interpreter.run
  end
end
