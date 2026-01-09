FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
    color { Tag::COLORS.sample }
    organization
  end
end
