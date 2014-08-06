require "test_helper"

describe Website do 
	before :each do
		# DatabaseCleaner.start
  #   Brand.destroy_all
		@website = FactoryGirl.create(:website_with_products) 
	end

  # after :each do
  #   DatabaseCleaner.clean
  # end
  
  describe "required settings" do
  	# it "should respond to support_email" do
  	# 	skip "Not sure what I'm hoping for here. Need to make sure sites all have a support email."
  	# 	website.support_email.wont_equal(nil)
  	# end
  end
 
end
