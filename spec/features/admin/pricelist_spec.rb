require "rails_helper"

feature "Admin Pricing", :devise do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryGirl.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
    @dealer_pricing_type = FactoryGirl.create(:pricing_type, brand: @brand, pricelist_order: 1)
    @artist_pricing_type = FactoryGirl.create(:pricing_type, brand: @brand, pricelist_order: 0)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
  end

  # after :each do
  #   DatabaseCleaner.clean
  # end

  describe "Pricing types list" do
    before do
      visit admin_pricing_types_path(locale: I18n.default_locale)
    end

    it "should list pricing types" do
      expect(page).to have_link @dealer_pricing_type.name, href: edit_admin_pricing_type_path(@dealer_pricing_type, locale: I18n.default_locale)
    end

    it "should show which pricing types are included on price list" do
      expect(page).to have_xpath("//tr[@id='pricing_type_#{@dealer_pricing_type.id}']", text: "Yes")
      expect(page).to have_xpath("//tr[@id='pricing_type_#{@artist_pricing_type.id}']", text: "No")
    end

  end

  describe "Create pricing type" do
    before do
      visit admin_pricing_types_path(locale: I18n.default_locale)
      click_on "New Pricing type"
    end

    it "should create a new pricing type for the brand" do
      count_all = PricingType.count
      fill_in "pricing_type_name", with: "Dealer Price"
      click_on "Create"

      expect(PricingType.count).to eq(count_all + 1)
      expect(PricingType.last.brand_id).to eq(@brand.id)
    end
  end

  describe "Updating prices" do
    before do
      @product = @website.products.first
      @product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @dealer_pricing_type, price: 200.99)
      @product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @artist_pricing_type, price: 199.95)
      visit admin_product_prices_path(locale: I18n.default_locale)
    end

    it "should add/update the price for the given product" do
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[0]][price]", with: "19.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[1]][price]", with: "19.99"
      click_on "save changes"

      expect(@product.price_for(@dealer_pricing_type).to_f).to eq(19.99)
      expect(@product.price_for(@artist_pricing_type).to_f).to eq(19.99)
    end
  end

  describe "Product prices overview" do
    before do
      visit admin_product_prices_path(locale: I18n.default_locale)
    end

    it "should have a button to export price list to Excel" do
      expect(page).to have_link "Excel", href: admin_product_prices_path(loc: "us", format: 'xls', locale: I18n.default_locale)
      expect(page).to have_link "Excel", href: admin_product_prices_path(loc: "intl", format: 'xls', locale: I18n.default_locale)
    end

    it "should have a form to update prices" do
      expect(page).to have_field "product_attr[#{@website.products.first.to_param}][msrp]"
    end

    it "should have fields to update the pricing type values" do
      expect(page).to have_field "product_attr[#{@website.products.first.to_param}][product_prices_attributes[0]][price]"
    end

    it "should update the price" do
      @product = @website.products.first

      fill_in "product_attr[#{@product.to_param}][msrp]", with: "199.99"
      fill_in "product_attr[#{@product.to_param}][street_price]", with: "99.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[0]][price]", with: "19.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[1]][price]", with: "19.99"
      click_on "save changes"

      @product.reload
      expect(@product.msrp.to_f).to eq(199.99)
      expect(@product.street_price.to_f).to eq(99.99)
      expect(@product.price_for(@dealer_pricing_type).to_f).to eq(19.99)
    end
  end

end
