FactoryBot.define do
  factory :visit do
    ga_visit_id { |i| "123#{i}" }

    association :channel
    association :device
    association :visitor
  end
end
