FactoryBot.define do
  factory :calendar_entry do
    calendar_notification { nil }
    user { nil }
  end
end
