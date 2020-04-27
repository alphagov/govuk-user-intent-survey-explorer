FactoryBot.define do
  factory :survey_phrase do
    association :phrase
    association :survey_answer
  end
end
