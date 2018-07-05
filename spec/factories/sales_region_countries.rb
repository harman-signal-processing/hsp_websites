FactoryBot.define do
  factory :sales_region_country do
    sequence(:name) {|n| "CountryName #{n}"}
    sales_region
  end
end
