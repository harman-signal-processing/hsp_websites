FactoryGirl.define do
   
  factory :online_retailer do
  	name "Musicians Enemy"
  	active true
  end

  factory :online_retailer_link do
  	product
  	online_retailer
  	brand
  	url 'http://nuthin.lvh.me/bla/bla.html'
  end

end