require "rails_helper"

RSpec.describe "toolkit/products/show.html.erb", as: :view do

  before do
    @brand = FactoryGirl.create(:brand)
    assign(:brand, @brand)
    assign(:images, [])
  end

  context "Current product" do
    before do
      @product = FactoryGirl.create(:product, brand: @brand, description: "Foo bar's are delicious")
      assign(:product, @product)

      render
    end

    it "should have product content" do
      expect(rendered).to have_content @product.description
    end
  end

  context "discontinued product pages" do
    before do
      discontinued = FactoryGirl.create(:product_status, shipping: false, discontinued: true)
      @discontinued_product = FactoryGirl.create(:product, brand: @brand, product_status: discontinued, description: "Iz no good no mo.")
      assign(:product, @discontinued_product)

      render
    end

    it "should have product content" do
      expect(rendered).to have_content @discontinued_product.description
    end

    it "should clearly identify the product as discontinued" do
      expect(rendered).to have_content "This product has been discontinued"
    end
  end

  context "announced product pages" do
    before do
      announced = FactoryGirl.create(:product_status, shipping: false)
      @product = FactoryGirl.create(:product, brand: @brand, product_status: announced, description: "Here it comes..")
      assign(:product, @product)

      render
    end

    it "should have product content" do
      expect(rendered).to have_content @product.description
    end

    it "should identify the product as not-shipping yet" do
      expect(rendered).to have_content "subject to change"
    end
  end

end
