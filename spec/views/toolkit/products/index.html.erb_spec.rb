require "rails_helper"

RSpec.describe 'toolkit/products/index.html.erb', as: :view do

  before :all do
    @brand = FactoryGirl.create(:brand)
  end

  before :each do
    @product = FactoryGirl.build(:product, brand: @brand)
    assign(:brand, @brand)
  end

  it "index should link to product" do
    @product.save

    render

    expect(rendered).to have_link(@product.name, toolkit_brand_product_path(@brand, @product))
  end

  it "should include products which are announced but not yet in production" do
    announced = FactoryGirl.create(:product_status, shipping: false, discontinued: false, show_on_website: true)
    @product.product_status = announced
    @product.save

    render

    expect(rendered).to have_link(@product.name, href: toolkit_brand_product_path(@brand, @product))
  end

  # This functionality gets debated constantly. Should we show product information
  # to our dealers and distributors before the product is actually announced?
  # As of 10/17/2014, the answer is "Yes." However, I can't get it to show on the
  # main page. It does show up when you go into the product family page.
  it "should NOT include products which are in development" do
    in_development = FactoryGirl.create(:product_status, shipping: false, show_on_website: false)
    @product.product_status = in_development
    @product.save

    render

    expect(rendered).not_to have_link(@product.name)
  end

  it "should NOT link to discontinued products" do
    discontinued = FactoryGirl.create(:product_status, shipping: false, discontinued: true)
    @product.product_status = discontinued
    @product.save

    render

    expect(rendered).not_to have_link(@product.name)
  end
end
