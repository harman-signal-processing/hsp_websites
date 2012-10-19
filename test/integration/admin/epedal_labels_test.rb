require "minitest_helper"

describe "Admin epedal Labels Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, istomp_coverflow: 1, url: "digitech.lvh.me")
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    @gooberator = FactoryGirl.create(:product, name: "Gooberator", brand: @brand, layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    Website.any_instance.stubs(:epedal_label_order_recipient).returns("epedal_fulfillment@harman.com")
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 

    @user = FactoryGirl.create(:user, market_manager: true, password: "password")
    admin_login_with(@user, "password", @website)
  end

  describe "managing label sheets" do 

  end

  describe "managing label sheet orders" do 

  end

  describe "label order fulfillment" do
    before do
        @sheet = FactoryGirl.create(:label_sheet, product_ids: [@gooberator.id, @fooberator.id].join(", "))
        @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id])
        visit admin_label_sheet_order_url(@order, host: @website.url, locale: I18n.default_locale)
    end

    it "should send an email to the user with the mailing date" do
        click_link 'mark shipped'
        last_email.to.must_include(@order.email)
        last_email.subject.must_have_content("epedal labels")
        last_email.body.must_have_content "today"
        @order.reload
        @order.mailed_on.blank?.wont_equal(true)
        page.must_have_content "Success"
    end

  end

end