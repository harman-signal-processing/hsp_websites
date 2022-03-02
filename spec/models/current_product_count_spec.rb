require 'rails_helper'

RSpec.describe CurrentProductCount, type: :model do

  before :all do
    @brand = create(:brand)
    @website = create(:website, brand: @brand)
    ProductStatus.clear_instance_variables
    @product_family = FactoryBot.create(:product_family_with_products, brand: @brand, products_count: 3)
    @current_product_count = create(:current_product_count, product_family: @product_family)
  end

  subject { @current_product_count }
  it { should respond_to :product_family }

  describe "Counting current products" do
    it "should count 'em up" do
      expect(@current_product_count.current_products_plus_child_products_count).to eq(3)
    end

    it "should decrement when a product is removed" do
      the_count = @current_product_count.current_products_plus_child_products_count
      pfp = @product_family.product_family_products.first
      pfp.destroy

      @current_product_count.reload
      expect(@current_product_count.current_products_plus_child_products_count).to eq(the_count - 1)
    end

    it "should increment when a product is added" do
      the_count = @current_product_count.current_products_plus_child_products_count
      new_product = create(:product, brand: @brand)
      create(:product_family_product, product_family: @product_family, product: new_product)

      @current_product_count.reload
      expect(@current_product_count.current_products_plus_child_products_count).to eq(the_count + 1)
    end
  end

end
