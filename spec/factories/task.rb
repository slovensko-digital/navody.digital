FactoryBot.define do
  factory :task do
    association :step

    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    type { 'SimpleTask' }
    url { Faker::Internet.url }
    sequence(:position) { |n| n }
  end
end
