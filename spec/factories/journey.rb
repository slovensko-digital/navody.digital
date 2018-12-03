FactoryBot.define do
  factory :journey do
    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    keywords { Faker::Commerce.department(5).gsub(/,/, '') }
    published_status { 'PUBLISHED' }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph(5) }
    sequence(:position) { |n| n }
  end
end
