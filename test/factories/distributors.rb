# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :distributor do
		sequence(:name) {|n| "Distributor #{n}" }
    detail "124 some foreign address..."
    country "Zambowbya"
    sequence(:email) {|n| "dealer#{n}@something.com"} 
    sequence(:account_number) {|n| ("7%09d" % n).to_s}
	end
end

FactoryGirl.define do
  factory :distributor_user do
    distributor
    user
  end
end
