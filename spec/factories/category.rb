FactoryBot.define do
  factory :category do
    sequence(:name) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    featured { true }
  end
end
