require "minitest_helper"

describe "epedal Labels Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, istomp_coverflow: 1, url: "digitech.lvh.me")
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    @gooberator = FactoryGirl.create(:product, name: "Gooberator", brand: @brand, layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
    @zooberator = FactoryGirl.create(:product, name: "Zooberator", brand: @brand, layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @zooberator, parent_product: @istomp)
    @stompshop = FactoryGirl.create(:software, name: "Stomp Shop", layout_class: "stomp_shop", brand: @brand)
    FactoryGirl.create(:product_software, product: @istomp, software: @stompshop)
    @sheet = FactoryGirl.create(:label_sheet, product_ids: [@gooberator.id, @fooberator.id].join(", "))
    Website.any_instance.stubs(:istomp_coverflow).returns(1)
    Website.any_instance.stubs(:epedal_label_order_recipient).returns("epedal_fulfillment@harman.com")
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  describe "an epedal page" do 
    before do
        visit product_url(@gooberator, host: @website.url, locale: I18n.default_locale)
    end

    it "should have a button to order a sheet" do
        must_have_link "Label", href: epedal_labels_order_form_path(@gooberator, locale: I18n.default_locale)
    end

    it "should auto-select the corresponding sheet for the referring epedal page" do
        click_on "Label"
        ch = find(:xpath, "//input[@type='checkbox'][@value='#{@sheet.id}']")
        ch.checked?.must_equal("checked")
    end

    it "should not show the button if the label is not on any sheets" do
        visit product_url(@zooberator, host: @website.url, locale: I18n.default_locale)
        wont_have_link "Label"
    end
  end

  describe "no configured recipient" do 
    before do
        Website.any_instance.stubs(:epedal_label_order_recipient).returns("")
        visit product_url(@gooberator, host: @website.url, locale: I18n.default_locale)
    end

    it "should not show the button" do
        wont_have_link "Label"
    end
  end


  describe "label ordering" do
    before do
        visit epedal_labels_order_form_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should not auto-check label sheet boxes if not coming from epedal page" do
        ch = find(:xpath, "//input[@type='checkbox'][@value='#{@sheet.id}']")
        ch.checked?.wont_equal("checked")
    end

    it "should have order form with sheets which can be selected" do 
        must_have_xpath "//input[@type='checkbox'][@value='#{@sheet.id}']"
    end

    it "should have fields for the customer details" do
        must_have_xpath "//input[@id='label_sheet_order_name']"
        must_have_xpath "//input[@id='label_sheet_order_email']"
        must_have_xpath "//input[@id='label_sheet_order_address']"
        must_have_xpath "//input[@id='label_sheet_order_city']"
        must_have_xpath "//input[@id='label_sheet_order_state']"
        must_have_xpath "//input[@id='label_sheet_order_postal_code']"
        must_have_xpath "//select[@id='label_sheet_order_country']"
    end

    it "should prompt for a subscription" do
        must_have_xpath "//input[@id='label_sheet_order_subscribe'][@type='checkbox']"
    end

    it "should require user fields to submit order" do
        select_sheet(@sheet)
        click_on "Submit"
        wont_have_content "at least one label sheet"
        must_have_content "Name can't be blank"
        must_have_content "Email can't be blank"
    end

    it "should require at least one sheet to submit order" do
        fill_in_customer_info
        click_on "Submit"
        must_have_content "at least one label sheet"
    end

    # it "should allow the user to create a password if desired"

    it "should show a thanks after the order" do
        fill_in_customer_info
        select_sheet(@sheet)
        click_on "Submit"
        must_have_content "Thank"
    end

    it "should assign the label sheets when submitted" do
        fill_in_customer_info
        select_sheet(@sheet)
        click_on "Submit"
        LabelSheetOrder.last.label_sheets.must_include(@sheet)
    end

    def select_sheet(sheet)
        check "label_sheet_order_label_sheet_ids_#{sheet.id}"
    end

    def fill_in_customer_info
        fill_in 'label_sheet_order_name', with: "Joe"
        fill_in 'label_sheet_order_email', with: "joe@joe.com"
        fill_in 'label_sheet_order_address', with: "1234"
        fill_in 'label_sheet_order_city', with: "nowhere"
        fill_in 'label_sheet_order_state', with: "ST"
        fill_in 'label_sheet_order_postal_code', with: "123"
        select "United States", from: 'label_sheet_order_country'
    end
  end

  describe "label order fulfillment" do
    before do
        @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id])
    end

    it "should send an email when completing the order" do
        last_email.to.must_include(@website.epedal_label_order_recipient)
        last_email.body.must_have_content @order.name
        last_email.body.must_have_content @order.address
        last_email.body.must_have_content @order.email
    end

    it "should have an easy URL in the email to mark it shipped" do
        last_email.body.must_have_link label_sheet_order_fulfillment_url(@order, @order.secret_code, host: @website.url, locale: I18n.default_locale)
    end

    it "should send an email to the user with the mailing date" do
        visit label_sheet_order_fulfillment_url(@order, @order.secret_code, host: @website.url, locale: I18n.default_locale)
        last_email.to.must_include(@order.email)
        last_email.subject.must_have_content("epedal labels")
        last_email.body.must_have_content "today"
        @order.reload
        @order.mailed_on.blank?.wont_equal(true)
        page.must_have_content "Success"
    end

    # it "should not send the email if we waited 6 weeks to send it"

    it "should fail fulfillment if code doesnt match" do
        visit label_sheet_order_fulfillment_url(@order, "something-wrong", host: @website.url, locale: I18n.default_locale)
        page.wont_have_content "Success"
        @order.reload
        @order.mailed_on.blank?.must_equal(true)
    end
  end

end