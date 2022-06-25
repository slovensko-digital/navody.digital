FactoryBot.define do
  factory :my_user_feed_entry, class: 'My::UserFeedEntry' do
    user { nil }
    thing { nil }
    identifier { "MyString" }
    status { "MyString" }
    deadline_at { "2022-06-25 15:47:45" }
    custom_fields { "" }
    journey { nil }
    last_checked_at { "2022-06-25 15:47:45" }
    type { "" }
  end
end
