FactoryBot.define do
  factory :step do
    association :journey

    title { Faker::Commerce.product_name }
    keywords { Faker::Commerce.department(5).gsub(/,/, '') }
    is_waiting_step { false }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph(5) }
  end
end
