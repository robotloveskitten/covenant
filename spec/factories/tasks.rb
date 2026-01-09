FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    task_type { "task" }
    status { "not_started" }
    default_view { "document" }
    position { 1 }
    organization
    association :creator, factory: :user

    trait :strategy do
      task_type { "strategy" }
    end

    trait :initiative do
      task_type { "initiative" }
    end

    trait :epic do
      task_type { "epic" }
    end

    trait :in_progress do
      status { "in_progress" }
    end

    trait :completed do
      status { "completed" }
    end

    trait :blocked do
      status { "blocked" }
    end

    trait :kanban_view do
      default_view { "kanban" }
    end

    trait :with_assignee do
      association :assignee, factory: :user
    end

    trait :with_due_date do
      due_date { 1.week.from_now }
    end
  end
end
