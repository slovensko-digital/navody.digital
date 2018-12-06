FactoryBot.define do
  factory :user_journey do
    association :user
    association :journey
  end
end
