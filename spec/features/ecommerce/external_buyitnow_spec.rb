feature "External Buy It Now" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @product = @website.products.first
    @online_retailer = FactoryBot.create(:online_retailer, retailer_logo: File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')))
    @retailer_link = FactoryBot.create(:online_retailer_link, online_retailer: @online_retailer, product: @product, brand: @website.brand, exclusive: true)
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "a product with an exclusive buy it now provider" do
    it "shows the logo on the product page and links directly to retailer" do
      visit product_path(@product, locale: I18n.default_locale)

      find("img[src='#{ @online_retailer.retailer_logo.url(:exclusive) }']")
      expect(page).to have_link("Buy It Now", href: @retailer_link.url, class: "buy_it_now_popup")
      expect(page).to have_content("You are now leaving the #{ @website.brand.name } website.")
    end
  end

end
