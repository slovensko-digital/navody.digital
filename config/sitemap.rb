SitemapGenerator::Sitemap.default_host = "https://navody.digital"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

sitemap_config = Rails.application.config_for(:sitemap)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  aws_access_key_id: sitemap_config[:access_key_id],
  aws_secret_access_key: sitemap_config[:secret_access_key],
  fog_provider: 'AWS',
  fog_public: true,
  fog_region: sitemap_config[:region],
  fog_directory: sitemap_config[:bucket],
  fog_path_style: sitemap_config[:path_style],
  fog_storage_options: {
    endpoint: sitemap_config[:endpoint],
  },
)

SitemapGenerator::Sitemap.create do
  Journey.find_each do |journey|
    add journey_path(journey.slug), lastmod: journey.updated_at
    journey.steps.find_each do |step|
      add journey_step_path(journey, step), lastmod: step.updated_at
    end
  end

  Page.find_each do |page|
    if page.is_faq?
      add faq_path(page.slug), lastmod: page.updated_at
    else
      add page_path(page.slug), lastmod: page.updated_at
    end
  end

  QuickTip.find_each do |tip|
    add quick_tip_path(tip), lastmod: tip.updated_at
  end

  add faqs_path
  add 'aplikacie/volby-do-europskeho-parlamentu'
end
