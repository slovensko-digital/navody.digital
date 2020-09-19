FactoryBot.define do
  factory :current_topic do
    key { Faker::Lorem.paragraph(sentence_count: 1) }
    value { Faker::Lorem.paragraph(sentence_count: 10) }
    enabled { true }
  end
end
