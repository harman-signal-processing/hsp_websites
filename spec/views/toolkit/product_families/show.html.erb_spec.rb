require "rails_helper"

RSpec.describe "toolkit/product_families/show.html.erb", as: :view do

  before :all do
    @brand = FactoryBot.create(:brand)
    @product = FactoryBot.create(:product, brand: @brand)
    @product_family = FactoryBot.create(:product_family, brand: @brand)
    assign(:brand, @brand)
    assign(:product_family, @product_family)
  end

  it "should link to current products" do
    FactoryBot.create(:product_family_product, product: @product, product_family: @product_family)

    render

    expect(rendered).to have_link(@product.name)
  end

  it "should link to announced products" do
    announced = FactoryBot.create(:product_status, shipping: false)
    @announced_product = FactoryBot.create(:product, brand: @brand, product_status: announced)
    FactoryBot.create(:product_family_product, product: @announced_product, product_family: @product_family)

    render

    expect(rendered).to have_link(@announced_product.name)
  end

  # This functionality gets debated constantly. Should we show product information
  # to our dealers and distributors before the product is actually announced?
  # As of 10/17/2014, the answer is "Yes."
  it "should also link to products in-development" do
    in_development = FactoryBot.create(:product_status, shipping: false, show_on_website: false)
    @developing_product = FactoryBot.create(:product, brand: @brand, product_status: in_development)
    FactoryBot.create(:product_family_product, product: @developing_product, product_family: @product_family)

    render

    expect(rendered).to have_link(@developing_product.name)
  end

  it "should link to discontinued products at the bottom" do
    discontinued = FactoryBot.create(:product_status, shipping: false, discontinued: true)
    @discontinued_product = FactoryBot.create(:product, brand: @brand, product_status: discontinued)
    FactoryBot.create(:product_family_product, product: @discontinued_product, product_family: @product_family)

    render

    expect(rendered).to have_content "Discontinued"
    expect(rendered).to have_link @discontinued_product.name
  end

end
