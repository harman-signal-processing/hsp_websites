require "test_helper"

describe "Admin epedal Labels Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
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
    @sheet = FactoryGirl.create(:label_sheet, product_ids: [@gooberator.id, @fooberator.id].join(", "))
    @user = FactoryGirl.create(:user, market_manager: true, password: "password")
    admin_login_with(@user, "password", @website)
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "managing label sheets" do 
    before do
      @zooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
      FactoryGirl.create(:parent_product, product: @zooberator, parent_product: @istomp)
      visit admin_label_sheets_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should list current sheets" do
      must_have_link @sheet.name, href: admin_label_sheet_path(@sheet, host: @website.url, locale: I18n.default_locale)
    end

    it "should create a new sheet" do
      click_on "New label sheet"
      fill_in 'label_sheet_name', with: "Yo Mama"
      fill_in 'label_sheet_product_ids', with: @zooberator.to_param
      click_on 'Create'
      must_have_content "Yo Mama"
      # save_and_open_page
      LabelSheet.last.products.must_include(@zooberator)
    end
  end

  describe "managing label sheet orders" do 
    before do
        @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id], subscribe: true)
        visit admin_label_sheet_orders_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should link to existing orders" do
      must_have_link @order.name
    end

    it "should show the order details" do
      click_on @order.name
      must_have_content @order.address
      must_have_content @order.city
      must_have_content @order.state
      must_have_content @order.postal_code
      must_have_content @order.email
      must_have_content @order.country
      must_have_content @order.expanded_label_sheets.first.name
      must_have_content "Subscribe? Yes"
    end

  end

  describe "label order fulfillment" do
    before do
        @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id, @sheet.id])
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

  describe "data export" do
    before do
      @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id, @sheet.id])
      visit admin_label_sheet_orders_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should have a button to export all" do 
      must_have_link "Export All", href: admin_label_sheet_orders_path(format: 'xls', locale: I18n.default_locale)
    end

    # it "should respond with an excel file for all" do
    #   click_on "Export All"
    #   wont_have_content "Error"
    # end

    it "should have a button to export subscribers only" do
      must_have_link "Export Subscribers", href: subscribers_admin_label_sheet_orders_path(format: 'xls', locale: I18n.default_locale)
    end

    # it "should respond with an excel file for subscribers" do
    #   click_on "Export Subscribers"
    #   wont_have_content "Error"
    # end
  end

end