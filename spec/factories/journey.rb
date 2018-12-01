FactoryBot.define do
  factory :journey do
    title { '%s %d' % [Faker::Commerce.product_name, rand(1..1000)] }
    keywords { Faker::Commerce.department(5).gsub(/,/, '') }
    published_status { 'PUBLISHED' }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph(5) }
  end
end
