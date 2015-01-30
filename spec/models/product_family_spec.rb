require "rails_helper"

RSpec.describe ProductFamily, :type => :model do

	describe "tree" do

		before :each do
			@digitech = FactoryGirl.create(:digitech_brand)
			@pedals = FactoryGirl.create(:product_family, brand: @digitech)
		end

	  it "should not be its own parent" do
	    @pedals.parent_id = @pedals.id
      expect { @pedals.save! }.to raise_error(ActiveRecord::RecordInvalid)

	    @pedals.reload
      expect(@pedals.parent_id).not_to eq(@pedals.id)
	  end

  end

end
