FactoryBot.define do
  factory :phrase_generic_phrase do
    association :phrase
    association :generic_phrase
  end
end
