FactoryBot.define do
  factory :user do
  	sequence(:name) {|n| "User #{n}"}
    sequence(:email) { |n| "user#{n}@harman.com" }
    ## Devise fields: ##
    password "pass123"
    password_confirmation { password }
    ## Roles ##
    admin false
    customer_service false
    online_retailer false
    translator false
    rohs false
    market_manager false
    artist_relations false
    engineer false
    clinician false
    rep false
    rso false
    sales_admin false
    dealer false
    distributor false
    marketing_staff false
    invitation_code HarmanSignalProcessingWebsite::Application.config.employee_invitation_code
  end
end