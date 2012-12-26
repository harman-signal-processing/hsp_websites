require "minitest_helper"

describe Website do 
  let(:website) { FactoryGirl.create(:website_with_products) }
  
  context "required settings" do
  	# it "should respond to support_email" do
  	# 	skip "Not sure what I'm hoping for here. Need to make sure sites all have a support email."
  	# 	website.support_email.wont_equal(nil)
  	# end
  end
 
end
