FactoryBot.define do
  factory :sales_region do
    sequence(:name) {|n| "RegionName #{n}"}
    brand
    support_email { "foo@foo.com" }
  end
end
