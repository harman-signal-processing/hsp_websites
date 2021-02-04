require "rails_helper"

RSpec.describe ProductFamily, :type => :model do

  before :all do
    @product_family = FactoryBot.create(:product_family)
  end

  subject { @product_family }
  it { should respond_to :products }
  it { should respond_to :features }

	describe "tree" do

		before :each do
			@digitech = FactoryBot.create(:digitech_brand)
			@pedals = FactoryBot.create(:product_family, brand: @digitech)
		end

	  it "should not be its own parent" do
	    @pedals.parent_id = @pedals.id
      expect(@pedals.valid?).to be(false)
	  end

  end

end
