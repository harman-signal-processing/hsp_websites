require "rails_helper"

feature "iStomp-specific features" do

  before :all do
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand)
    stompboxes = FactoryGirl.create(:product_family, name: "Stompboxes", brand: @brand)
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    FactoryGirl.create(:product_family_product, product_family: stompboxes, product: @istomp)
    @gooberator = FactoryGirl.create(:product,
      name: "Gooberator",
      brand: @brand,
      msrp: 4.99,
      layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product,
      name: "Fooberator",
      brand: @brand,
      layout_class: "epedal")
    @impossible = FactoryGirl.create(:product,
      name: "The Impossible",
      brand: @brand,
      msrp: 19.99,
      sale_price: 19.99,
      layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @impossible, parent_product: @istomp)
    @stompshop = FactoryGirl.create(:software, name: "Stomp Shop", layout_class: "stomp_shop", brand: @brand)
    FactoryGirl.create(:product_software, product: @istomp, software: @stompshop)

    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  before :each do
    allow_any_instance_of(Website).to receive(:featured_epedals).and_return("#{@gooberator.to_param}|#{@impossible.to_param}")
  end

  # Appears here instead of view spec because view has a hard time with my
  # crazy partials resolving
  context "product page" do
    before do
      visit product_path(id: @istomp.to_param, locale: I18n.default_locale)
    end

  	it "should have the featured epedal bottom panel" do
  		expect(page).to have_xpath("//div[@id='featured_callout'][@class='callout right_callout']")
  	end

    it "should not have the burst on artist pedals in the featured panel" do
      expect(page).not_to have_link("99 cents", href: product_path(id: @impossible.to_param, locale: I18n.default_locale))
    end

    it "should have the 99 cent burst in the featured panel" do
      expect(page).to have_link("99 cents", href: product_path(id: @gooberator.to_param, locale: I18n.default_locale))
    end

  	it "should have the stompshop bottom panel" do
      expect(page).to have_xpath("//div[@id='stomp_shop_callout'][@class='callout left_callout']")
  	end

  	it "should have the sub pedals in the show all section" do
      expect(page).to have_content @gooberator.name
      expect(page).to have_content @fooberator.name
  	end
  end

  context "stomp shop page" do
  	before do
      visit software_path(id: @stompshop.to_param, locale: I18n.default_locale)
  	end

  	it "should use the stompshop layout" do
      expect(page).to have_xpath("//section[@id='product_content'][@class='#{@stompshop.layout_class}']")
  	end

  	it "should have the featured epedal bottom panel" do
  		expect(page).to have_xpath("//div[@id='featured_callout'][@class='callout right_callout']")
  	end

  	it "should have the istomp bottom panel" do
  		expect(page).to have_xpath("//div[@id='istomp_callout'][@class='callout left_callout']")
  	end
  end

  context "epedal page" do
  	before do
      visit product_path(id: @gooberator.to_param, locale: I18n.default_locale)
  	end

  	it "should NOT jump directly to siblings in coverflow" do
  		expect(page).not_to have_xpath("//div[@id='coverflow_settings'][@data-jump='true']")
  	end

  	it "should have the istomp bottom panel" do
  		expect(page).to have_xpath("//div[@id='istomp_callout'][@class='callout left_callout']")
  	end

  	it "should have the stompshop bottom panel" do
  		expect(page).to have_xpath("//div[@id='stomp_shop_callout'][@class='callout right_callout']")
  	end
  end

  context "featured on-sale epedal page" do
    before do
      visit product_path(@gooberator, locale: I18n.default_locale)
    end

    it "should have the 99 cent price burst" do
      expect(page).to have_xpath("//img[@src='/assets/digitech/istomp/99cent_burst.png']")
    end

    it "should have the regular price" do
      expect(page).to have_content "Regular Price: $#{@gooberator.msrp.to_s}"
    end
  end

  context "featured artist pedal page" do
    before do
      visit product_path(@impossible, locale: I18n.default_locale)
    end

    it "should not have the 99 cent price burst" do
      expect(page).not_to have_xpath("//img[@src='/assets/digitech/istomp/99cent_burst.png']")
    end

    it "should show the price text" do
      expect(page).to have_content "Price: $#{@impossible.msrp.to_s}"
    end
  end

end
