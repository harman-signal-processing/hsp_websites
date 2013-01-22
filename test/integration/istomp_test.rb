require "minitest_helper"

describe "iStomp Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, istomp_coverflow: 1)
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
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
    Website.any_instance.stubs(:featured_epedals).returns("#{@gooberator.to_param}|#{@impossible.to_param}")
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

    # Coverflow is being retired, like Roby Urry
  	# it "should have label changers on the coverflow" do
  	# 	must_have_xpath("//div[@id='coverflow_settings'][@data-changelabel='true']")
  	# 	must_have_xpath("//div[@id='epedals'][@data-count='#{@istomp.sub_products.count}']")
  	# end

  	it "should have the featured epedal bottom panel" do
  		must_have_xpath("//div[@id='featured_callout'][@class='callout right_callout']")
  	end

    it "should not have the burst on artist pedals in the featured panel" do 
      wont_have_link "99 cents", href: product_path(@impossible, locale: I18n.default_locale)
    end

    it "should have the 99 cent burst in the featured panel" do 
      must_have_link "99 cents", href: product_path(@gooberator, locale: I18n.default_locale)
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

    # Coverflow is being retired, like Rob Urry
  	# it "should have popups on the coverflow" do
  	# 	must_have_xpath("//div[@id='coverflow_pops']")
  	# end

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
  	it "should NOT jump directly to siblings in coverflow" do
  		wont_have_xpath("//div[@id='coverflow_settings'][@data-jump='true']")
  	end
  	it "should have the istomp bottom panel" do
  		must_have_xpath("//div[@id='istomp_callout'][@class='callout left_callout']")
  	end
  	it "should have the stompshop bottom panel" do
  		must_have_xpath("//div[@id='stomp_shop_callout'][@class='callout right_callout']")
  	end
    
  end

  describe "featured on-sale epedal page" do 
    before do
      visit product_url(@gooberator, locale: I18n.default_locale, host: @website.url)
    end

    it "should have the 99 cent price burst" do 
      must_have_xpath("//img[@src='/assets/digitech/istomp/99cent_burst.png']")
    end   

    it "should have the regular price" do 
      must_have_content "Regular Price: $#{@gooberator.msrp.to_s}"
    end 
  end

  describe "featured artist pedal page" do 
    before do
      visit product_url(@impossible, locale: I18n.default_locale, host: @website.url)
    end

    it "should not have the 99 cent price burst" do 
      wont_have_xpath("//img[@src='/assets/digitech/istomp/99cent_burst.png']")
    end   

    it "should show the price text" do 
      must_have_content "Regular Price: $#{@impossible.msrp.to_s}"
    end 

  end

end