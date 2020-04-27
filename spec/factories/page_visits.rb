FactoryBot.define do
  factory :page_visit do
    association :page
    association :visit
  end
end
