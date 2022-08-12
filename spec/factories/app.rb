FactoryBot.define do
  factory :app do
    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    slug { title.parameterize }
    published_status { 'PUBLISHED' }
    sequence(:image_name) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
  end
end
