FactoryBot.define do
  factory :submission do
    uuid { "" }
    user { nil }
    anonymous_user_uuid { "" }
    email { "MyString" }
    callback_url { "MyString" }
    callback_step_id { nil }
    callback_step_stats { "MyString" }
    subscription_types { "MyString" }
    attachments { "" }
    extra { "" }
  end
end
