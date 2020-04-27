FactoryBot.define do
  factory :page do
    sequence(:base_path) { |i| "/test-page-#{i}" }
    created_at { "2020-04-27 15:04:51" }
    updated_at { "2020-04-27 15:04:51" }
  end
end
