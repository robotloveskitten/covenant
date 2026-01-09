FactoryBot.define do
  factory :invitation do
    organization
    association :invited_by, factory: :user
    sequence(:email) { |n| "invited#{n}@example.com" }
    role { "member" }

    trait :admin do
      role { "admin" }
    end

    trait :accepted do
      accepted_at { Time.current }
    end
  end
end
