FactoryBot.define do
  factory :task_dependency do
    association :task
    association :dependency, factory: :task
  end
end
