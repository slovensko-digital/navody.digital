FactoryBot.define do
  factory :user_step do
    association :user_journey
    association :step

    status { 'nothing' }
  end
end
