require "minitest_helper"

describe "epedal Labels Integration Test" do

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
    @sheet = FactoryGirl.create(:label_sheet, products: [@gooberator, @fooberator])
    Website.any_instance.stubs(:istomp_coverflow).returns(1)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  describe "an epedal page" do 
    it "should have a button to order a sheet" do
        visit product_url(@gooberator, host: @website.url, locale: I18n.default_locale)
        must_have_link "Label", href: epedal_labels_order_form_path
    end
  end

  describe "label ordering" do
    before do
        visit epedal_label_order_form_url(host: @website.url, locale: I18n.default_locale)
    end
    it "should have order form with sheets which can be selected" do 
        must_have_xpath "//input[@type='checkbox'][@value='#{@sheet.id}'][@name='label_sheets[]']"
    end
    it "should require a login to order"
    it "should review the order"
    it "should send an email when completing the order"
  end

end