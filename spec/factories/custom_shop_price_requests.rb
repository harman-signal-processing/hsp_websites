FactoryBot.define do
  factory :custom_shop_price_request do
    user
    custom_shop_cart
    account_number { "6789" }
    opportunity_number { "1231" }
    opportunity_name { "Opportunity Name" }
    location { "Opportunity Location" }
    description { "Project Description" }
    request_delivery_on { 6.months.from_now }

  end
end
