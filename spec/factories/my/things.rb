FactoryBot.define do
  factory :my_thing, class: 'My::Thing' do
    user { nil }
    name { "MyString" }
    identifier { "MyString" }
    custom_fields { "" }
    type { "" }
  end
end
