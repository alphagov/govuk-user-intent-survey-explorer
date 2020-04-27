FactoryBot.define do
  factory :survey_answer do
    sequence(:answer) { |n| "expected answer #{n}" }

    association :question
    association :survey
  end
end
