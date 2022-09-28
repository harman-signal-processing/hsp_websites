require "rails_helper"

RSpec.describe ProductFamily, :type => :model do

  before :all do
    @product_family = FactoryBot.create(:product_family)
  end

  subject { @product_family }
  it { should respond_to :products }
  it { should respond_to :features }
  it { should respond_to :customizable_attributes }

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

  describe ".customizable(website, locale)" do

    before do
      @website = create(:website_with_products)
      @product_family = @website.products.first.product_families.first
    end

    it "should not be customizable" do
      expect(ProductFamily.customizable(@website, I18n.default_locale)).not_to include(@product_family)
    end

    it "should be customizable" do
      @product_family.customizable_attributes << create(:customizable_attribute)
      expect(ProductFamily.customizable(@website, I18n.default_locale)).to include(@product_family)
    end
  end

  describe ".current_products_plus_child_products(website)" do
    before do
      @website = create(:website)
      @parent_family = FactoryBot.create(:product_family, brand: @website.brand)
      @child_with_products = FactoryBot.create(:product_family_with_products, brand: @website.brand, parent_id: @parent_family.id, products_count: 2)
    end

    it "should include child family products" do
      products = @parent_family.current_products_plus_child_products(@website)
      #expect(@child_with_products.current_products_plus_child_products(@website).length).to eq(2)
      expect(products.length).to eq(2)
    end
  end

end
