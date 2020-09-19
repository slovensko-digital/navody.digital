FactoryBot.define do
  factory :current_topic do
    body { Faker::Lorem.paragraph(sentence_count: 10) }
    enabled { true }
  end
end
