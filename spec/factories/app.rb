FactoryBot.define do
  factory :app do
    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    slug { title.parameterize }
    published_status { 'PUBLISHED' }
    short_description { Faker::Lorem.paragraph(sentence_count: 1) }
    sequence(:image_name) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
  end
end
