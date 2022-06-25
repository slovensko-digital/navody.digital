FactoryBot.define do
  factory :my_feed_entry_generator, class: 'My::FeedEntryGenerator' do
    journey { nil }
    type { "" }
  end
end
