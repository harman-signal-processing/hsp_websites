require "test_helper"

describe ProductFamily do 

	# before :each do
	# 	DatabaseCleaner.start
	# 	Brand.destroy_all
	# end

	# after :each do
	# 	DatabaseCleaner.clean
	# end

	describe "tree" do
  
		before :each do
			@digitech = FactoryGirl.create(:digitech_brand)
			@pedals = FactoryGirl.create(:product_family, brand: @digitech)
		end

	  it "should not be its own parent" do
	    @pedals.parent_id = @pedals.id 
	    assert_raises(ActiveRecord::RecordInvalid) { @pedals.save! }
	    @pedals.reload
	    assert_not_equal @pedals.parent_id, @pedals.id
	  end

  end
  
end