FactoryBot.define do
  factory :task do
    association :step

    sequence(:title) do |n|
      '%s %d' % [Faker::Commerce.product_name, n]
    end
    type { 'SimpleTask' }
    sequence(:position) { |n| n }

    trait :simple do
      type { 'SimpleTask' }
      url { nil }
    end

    trait :external_link do
      type { 'ExternalLinkTask' }
      url { Faker::Internet.url }
    end
  end
end
