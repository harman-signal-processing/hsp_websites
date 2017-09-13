require 'rails_helper'

RSpec.describe SpecificationGroup, type: :model do

  before :all do
    @specification_group = FactoryGirl.create(:specification_group)
  end

  subject { @specification_group }
  it { should respond_to(:name) }
  it { should respond_to(:specifications) }

  describe "determins which of its specifications pertain to a product" do

    before do
      @specification = FactoryGirl.create(:specification, specification_group: @specification_group)
      @product = FactoryGirl.create(:product)
      FactoryGirl.create(:product_specification, product: @product, specification: @specification)
    end

    it "includes relevant specs" do
      expect(@specification_group.specifications_for(@product)).to include(@specification)
    end

    it "excludes irrelevant specs" do
      p = FactoryGirl.create(:product)

      expect(@specification_group.specifications_for(p)).not_to include(@specification)
    end
  end
end
