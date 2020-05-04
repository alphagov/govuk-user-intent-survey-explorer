FactoryBot.define do
  factory :mention do
    association :phrase
    association :survey_answer
  end
end
