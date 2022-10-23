FactoryBot.define do
  factory :journey do
    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    keywords { Faker::Commerce.department(max: 5).gsub(/,/, '') }
    published_status { 'PUBLISHED' }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    short_description { Faker::Lorem.paragraph(sentence_count: 1) }
  end
end
