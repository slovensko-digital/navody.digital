require 'application_record'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://navody.digital"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  Journey.find_each do |journey|
    add journey_path(journey.slug), lastmod: journey.updated_at
    journey.steps.find_each do |step|
      add journey_step_path(journey, step), lastmod: step.updated_at
    end
  end

  Page.find_each do |page|
    add page_path(page.slug), lastmod: page.updated_at
  end

  
  add 'aplikacie/volby-do-europskeho-parlamentu'
end
