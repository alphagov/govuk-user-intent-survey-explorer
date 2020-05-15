FactoryBot.define do
  factory :phrase do
    phrase_text { |n| "find help #{n}" }
  end
end
