FactoryBot.define do
  factory :task_version do
    association :task
    association :user
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    sequence(:version_number) { |n| n }
  end
end
