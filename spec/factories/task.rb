FactoryBot.define do
  factory :task do
    association :step

    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    type { 'GenericTask' }
    url { Faker::Internet.url }
  end
end
