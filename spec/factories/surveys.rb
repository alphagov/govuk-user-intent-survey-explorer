FactoryBot.define do
  factory :survey do
    ga_primary_key { "68316545165465843" }
    started_at { DateTime.now }

    association :organisation
    association :visitor
  end
end
