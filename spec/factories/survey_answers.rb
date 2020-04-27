FactoryBot.define do
  factory :survey_answer do
    answer { "I found what I was looking for" }

    association :question
    association :survey
  end
end
