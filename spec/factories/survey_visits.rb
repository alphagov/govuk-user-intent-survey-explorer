FactoryBot.define do
  factory :survey_visit do
    association :survey
    association :visit
  end
end
