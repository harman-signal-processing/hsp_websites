FactoryBot.define do

  factory :warranty_registration do
		title { "Mr." }
		first_name { "Johnny" }
		last_name { "Johnson" }
		middle_initial { "J" }
		company { "Three's" }
		country { "USA" }
		email { "customer@holyschnikeys.com" }
		subscribe { false }
		brand
		product
		serial_number { "12345" }
		registered_on { 1.week.ago }
		purchased_on { 2.weeks.ago }
		purchased_from { "Some Dealer" }
		purchase_country { "USA" }
		purchase_price { "99.99" }
  end

end
