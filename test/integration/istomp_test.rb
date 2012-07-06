require "minitest_helper"

describe "iStomp Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, istomp_coverflow: 1)
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    @gooberator = FactoryGirl.create(:product, name: "Gooberator", brand: @brand, layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    @stompshop = FactoryGirl.create(:software, name: "Stomp Shop", layout_class: "stomp_shop", brand: @brand)
    FactoryGirl.create(:product_software, product: @istomp, software: @stompshop)
    Website.any_instance.stubs(:istomp_coverflow).returns(1)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  describe "istomp product page" do
  	before do
  		visit product_url(@istomp, locale: I18n.default_locale, host: @website.url)
  	end

  	it "should use the istomp layout" do
  		must_have_xpath("//link[@href='/assets/istomp.css']")
  		must_have_xpath("//script[@src='/assets/istomp.js']")
  		must_have_xpath("//section[@id='product_content'][@class='#{@istomp.layout_class}']")
  	end
  	it "should have label changers on the coverflow" do
  		must_have_xpath("//div[@id='coverflow_settings'][@data-changelabel='true']")
  		must_have_xpath("//div[@id='epedals'][@data-count='#{@istomp.sub_products.count}']")
  	end
  	it "should have the featured epedal bottom panel" do
  		must_have_xpath("//div[@id='featured_callout'][@class='callout right_callout']")
  	end
  	it "should have the stompshop bottom panel" do
  		must_have_xpath("//div[@id='stomp_shop_callout'][@class='callout left_callout']")
  	end
  	it "should have the sub pedals in the show all section" do
  		must_have_content @gooberator.name
  		must_have_content @fooberator.name
  	end

  end

  describe "stomp shop page" do
  	before do
  		visit software_url(@stompshop, locale: I18n.default_locale, host: @website.url)
  	end

  	it "should use the stompshop layout" do
  		must_have_xpath("//section[@id='product_content'][@class='#{@stompshop.layout_class}']")
  	end
  	it "should have popups on the coverflow" do
  		must_have_xpath("//div[@id='coverflow_pops']")
  	end
  	it "should have the featured epedal bottom panel" do
  		must_have_xpath("//div[@id='featured_callout'][@class='callout right_callout']")
  	end
  	it "should have the istomp bottom panel" do
  		must_have_xpath("//div[@id='istomp_callout'][@class='callout left_callout']")
  	end
  end

  describe "epedal page" do
  	before do
  		visit product_url(@gooberator, locale: I18n.default_locale, host: @website.url)
  	end

  	it "should use the epedal layout" do 
  		must_have_xpath("//section[@id='product_content'][@class='#{@gooberator.layout_class}']")
  	end
  	it "should jump directly to siblings in coverflow" do
  		must_have_xpath("//div[@id='coverflow_settings'][@data-jump='true']")
  	end
  	it "should have the istomp bottom panel" do
  		must_have_xpath("//div[@id='istomp_callout'][@class='callout left_callout']")
  	end
  	it "should have the stompshop bottom panel" do
  		must_have_xpath("//div[@id='stomp_shop_callout'][@class='callout right_callout']")
  	end
  end

end