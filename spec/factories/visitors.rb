FactoryBot.define do
  factory :visitor do
    intent_client_id { "MyString" }
    ga_primary_key { "MyString" }
    ga_full_visitor_id { 123456789.123 }
    created_at { "2020-04-27 15:04:51" }
    updated_at { "2020-04-27 15:04:51" }
  end
end
