FactoryBot.define do
  factory :calendar_notification do
    topic { nil }
    step { nil }
    name { "MyString" }
    description { "MyString" }
    kind { 1 }
  end
end
