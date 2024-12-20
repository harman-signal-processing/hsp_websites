require "rails_helper"

feature "Buy It Now" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    FactoryBot.create(:website_locale, website: @website, default: false, locale: "en-US")
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @product = @website.products.first
    @online_retailer = FactoryBot.create(:online_retailer)
    @retailer_link = FactoryBot.create(:online_retailer_link, online_retailer: @online_retailer, product: @product, brand: @website.brand)
    @locale = "en-US"
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "product page" do

  	it "should have buy it now links" do
      visit product_path(@product, locale: @locale) + '?geo=us&geo_country=us'

      expect(page).to have_link I18n.t('buy_it_now'), href: buy_it_now_product_path(@product, locale: @locale)
  		expect(page).to have_xpath("//div[@id='dealers']")
  	end

    it "should have RETAILER google tracker" do
      visit product_path(@product, locale: @locale) + '?geo=us&geo_country=us'
      # Best I match is the beginning of the tracker onclick code. The entire code is:
      # tracker (old) = "_gaq.push(['_trackEvent', 'BuyItNow-Dealer', '#{@online_retailer.name}', '#{@product.name}'])"
      # tracker (new) = "gtag('event', 'click', { 'event_category': 'BuyItNow-Dealer', 'event_action': '#{@online_retailer.name}', 'event_label': '#{@product.name}'})"
      expect(page).to have_xpath("//a[@href='#{@retailer_link.url}'][starts-with(@onclick, 'gtag')]")
    end

    describe "preferred retailer" do
    	it "should appear first" do
    		preferred_retailer = FactoryBot.create(:online_retailer, preferred: 1)
    		preferred_link = FactoryBot.create(:online_retailer_link, online_retailer: preferred_retailer, product: @product, brand: @website.brand)
        visit product_path(@product, locale: @locale) + '?geo=us&geo_country=us'
    		expect(page).to have_xpath("//div[@id='dealers']/div[@id='online_retailers']/ul/li[@class='retailer_logo preferred']/a[@href='#{preferred_link.url}']")
    	end
    end

    describe "URL param rbin=true" do
    	before do
    		visit product_path(@product, rbin: true, locale: @locale)
    	end

    	it "should select a random retailer to link directly" do
    		expect(page).to have_link I18n.t('buy_it_now')
    	end

    	it "should not link to any other retailers" do
    		expect(page).not_to have_xpath("//div[@id='dealers']")
    	end
    end

    describe "URL param bin=dealer-id" do
    	before do
    		visit product_path(@product, bin: @online_retailer.to_param, locale: @locale)
    	end

    	it "should link directly to the retailer" do
    		expect(page).to have_link I18n.t('buy_it_now'), href: @retailer_link.url
    	end

    	it "should not link to any other retailers" do
    		expect(page).not_to have_xpath("//div[@id='dealers']")
    	end
    end

  end

  describe "product buyitnow page" do
  	before do
  		@preferred_retailer = FactoryBot.create(:online_retailer, preferred: 1)
    	@preferred_link = FactoryBot.create(:online_retailer_link, online_retailer: @preferred_retailer, product: @product, brand: @website.brand)
    	visit buy_it_now_product_path(@product, locale: @locale)
    end

    it "should have buy it now links with RETAILER google tracker" do
      expect(page).to have_xpath("//a[@href='#{@retailer_link.url}'][starts-with(@onclick, 'gtag')]")
    end

  	it "preferred should appear first" do
  		preferred_retailer = FactoryBot.create(:online_retailer, preferred: 1)
  		preferred_link = FactoryBot.create(:online_retailer_link, online_retailer: preferred_retailer, product: @product, brand: @website.brand)
      visit product_path(@product, locale: @locale) + '?geo=us&geo_country=us'
  		expect(page).to have_xpath("//div[@id='dealers']/div[@id='online_retailers']/ul/li[@class='retailer_logo preferred']/a[@href='#{preferred_link.url}']")
  	end

  end

  describe "product is set to hide_buy_it_now_button" do
    before do
      @product.hide_buy_it_now_button = true
      @product.save
      visit product_path(@product, bin: @online_retailer.to_param, locale: @locale)
    end

    it "should not have the buy it now div" do
      expect(page).not_to have_xpath("//div[@id='dealers']")
    end

    it "should not have the buy it now button" do
      expect(page).not_to have_link I18n.t('buy_it_now'), href: buy_it_now_product_path(@product, locale: @locale)
    end

  end
end
