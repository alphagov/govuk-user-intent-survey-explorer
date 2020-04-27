FactoryBot.define do
  factory :survey_user_group do
    association :survey
    association :user_group
  end
end
