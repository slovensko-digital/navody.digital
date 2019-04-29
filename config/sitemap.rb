SitemapGenerator::Sitemap.default_host = "https://navody.digital"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

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

  add faqs_path
  add 'aplikacie/volby-do-europskeho-parlamentu'
end
