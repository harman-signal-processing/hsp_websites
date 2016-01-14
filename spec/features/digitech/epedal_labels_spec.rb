require "rails_helper"

feature "epedal labels ordering" do

  before :all do
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website, folder: "digitech", brand: @brand, url: "digitech.lvh.me")
    stompboxes = FactoryGirl.create(:product_family, name: "Stompboxes", brand: @brand)
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    FactoryGirl.create(:product_family_product, product_family: stompboxes, product: @istomp)
    @gooberator = FactoryGirl.create(:product, name: "Gooberator", brand: @brand, layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
    @zooberator = FactoryGirl.create(:product, name: "Zooberator", brand: @brand, layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @zooberator, parent_product: @istomp)
    @stompshop = FactoryGirl.create(:software, name: "Stomp Shop", layout_class: "stomp_shop", brand: @brand)
    FactoryGirl.create(:product_software, product: @istomp, software: @stompshop)
    @sheet = FactoryGirl.create(:label_sheet, products: [@gooberator.id, @fooberator.id].join(", "))
    @sheet2 = FactoryGirl.create(:label_sheet, products: [@zooberator.id].join(", "))

    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  before :each do
    allow_any_instance_of(Website).to receive(:epedal_label_order_recipient).and_return("epedal_fulfillment@harman.com")
  end

  context "an epedal page" do
    before do
      visit product_path(id: @gooberator.to_param, locale: I18n.default_locale)
    end

    it "should have a button to order a sheet" do
      expect(page).to have_link "Label", href: epedal_labels_order_form_path(@gooberator, locale: I18n.default_locale)
    end

    it "should auto-select the corresponding sheet for the referring epedal page" do
      click_on "Label"
      ch = find(:xpath, "//input[@type='checkbox'][@value='#{@sheet.id}']")

      expect(ch.checked?).to eq("checked")
    end

    it "should not show the button if the label is not on any sheets" do
      @mooberator = FactoryGirl.create(:product, name: "Mooberator", brand: @brand, layout_class: "epedal")
      FactoryGirl.create(:parent_product, product: @mooberator, parent_product: @istomp)

      visit product_path(id: @mooberator.to_param, locale: I18n.default_locale)

      expect(page).not_to have_link "Label"
    end
  end

  context "no configured recipient" do
    before do
      allow_any_instance_of(Website).to receive(:epedal_label_order_recipient).and_return("")

      visit product_path(id: @gooberator.to_param, locale: I18n.default_locale)
    end

    it "should not show the button" do
      expect(page).not_to have_link "Label"
    end
  end

  context "label ordering" do
    before do
      visit epedal_labels_order_form_path(locale: I18n.default_locale)
    end

    it "should not auto-check label sheet boxes if not coming from epedal page" do
      ch = find(:xpath, "//input[@type='checkbox'][@value='#{@sheet.id}']")

      expect(ch.checked?).not_to eq("checked")
    end

    it "should have order form with sheets which can be selected" do
      expect(page).to have_xpath "//input[@type='checkbox'][@value='#{@sheet.id}']"
    end

    it "should have fields for the customer details" do
      expect(page).to have_xpath "//input[@id='label_sheet_order_name']"
      expect(page).to have_xpath "//input[@id='label_sheet_order_email']"
      expect(page).to have_xpath "//input[@id='label_sheet_order_address']"
      expect(page).to have_xpath "//input[@id='label_sheet_order_city']"
      expect(page).to have_xpath "//input[@id='label_sheet_order_state']"
      expect(page).to have_xpath "//input[@id='label_sheet_order_postal_code']"
      expect(page).to have_xpath "//select[@id='label_sheet_order_country']"
    end

    it "should prompt for a subscription" do
      expect(page).to have_xpath "//input[@id='label_sheet_order_subscribe'][@type='checkbox']"
    end

    it "should require user fields to submit order" do
      select_sheet(@sheet)
      select_sheet(@sheet2)
      click_on "Submit"

      expect(page).not_to have_content "at least one label sheet"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email can't be blank"
    end

    it "should require at least one sheet to submit order" do
      fill_in_customer_info
      click_on "Submit"

      expect(page).to have_content "at least one label sheet"
    end

    it "should show a thanks after the order" do
      fill_in_customer_info
      select_sheet(@sheet)
      click_on "Submit"

      expect(page).to have_content "Thank"
    end

    it "should assign the label sheets when submitted" do
      fill_in_customer_info
      select_sheet(@sheet)
      click_on "Submit"

      expect(LabelSheetOrder.last.expanded_label_sheets).to include(@sheet)
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

  context "label order fulfillment" do
    before do
      @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id])
      @last_email = ActionMailer::Base.deliveries.last
    end

    it "should send an email when completing the order" do
      expect(@last_email.to).to include(@website.epedal_label_order_recipient)
      expect(@last_email.body).to have_content @order.name
      expect(@last_email.body).to have_content @order.address
      expect(@last_email.body).to have_content @order.email
    end

    it "should have an easy URL in the email to mark it shipped" do
      expect(@last_email.body).to have_content label_sheet_order_fulfillment_url(@order, @order.secret_code, host: @website.url, locale: I18n.default_locale)
    end

    it "should send an email to the user with the mailing date" do
      visit label_sheet_order_fulfillment_path(@order, @order.secret_code, locale: I18n.default_locale)

      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to include(@order.email)
      expect(last_email.subject).to have_content("epedal labels")
      expect(last_email.body).to have_content "today"

      @order.reload
      expect(@order.mailed_on.blank?).to be(false)
      expect(page).to have_content "Success"
    end

    it "should fail fulfillment if code doesnt match" do
      visit label_sheet_order_fulfillment_path(@order, "something-wrong", locale: I18n.default_locale)

      expect(page).not_to have_content "Success"

      @order.reload
      expect(@order.mailed_on.blank?).to be(true)
    end
  end

end
