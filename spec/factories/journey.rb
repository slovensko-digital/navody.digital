FactoryBot.define do
  factory :journey do
    title { Faker::Commerce.product_name }
    keywords { Faker::Commerce.department(5).gsub(/,/, '') }
    published_status { 'PUBLISHED' }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph(5) }
  end
end
