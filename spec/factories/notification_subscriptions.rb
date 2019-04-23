FactoryBot.define do
  factory :notification_subscription do
    user { nil }
    email { "MyString" }
    type { "" }
    confirmation_token { "" }
    confirmation_sent_at { "MyString" }
    confirmed_at { "MyString" }
  end
end
