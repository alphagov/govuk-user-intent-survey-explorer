FactoryBot.define do
  factory :survey do
    ga_primary_key { "68316545165465843" }

    association :organisation
    association :visitor
  end
end
