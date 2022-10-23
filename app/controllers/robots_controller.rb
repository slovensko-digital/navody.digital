class RobotsController < ApplicationController
  layout false

  def index
    sitemap_config = Rails.application.config_for(:sitemap)

    @public_url = if sitemap_config[:public_url].present?
      sitemap_config[:public_url]
    else
      'https://navody.digital/sitemaps/sitemap.xml.gz'
    end

    render Rails.env.production? ? 'allow' : 'disallow'
  end
end
