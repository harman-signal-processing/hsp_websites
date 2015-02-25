require "rails_helper"

RSpec.describe Product, :type => :model do

  before do
    @product = FactoryGirl.build_stubbed(:product)
  end

  subject { @product }
  it { should respond_to(:brand) }
  it { should respond_to(:sap_sku) }

  describe "SKU validation" do
    it "should allow blank SKUs" do
      @product.sap_sku = nil
      expect(@product.valid?).to be(true)
    end

    it "should not allow an email address" do
      @product.sap_sku = "someone@email.com"
      expect(@product.valid?).to be(false)
    end
  end
end
