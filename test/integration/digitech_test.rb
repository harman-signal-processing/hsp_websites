require "test_helper"

describe "DigiTech Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "home page" do
    it "should respond with the brand layout" do
      visit root_url(locale: I18n.default_locale, host: @website.url)
      page.must_have_xpath("//div[@id='big_bottom_box_container']")
    end
  end

  # Since Digitech has different product family views, make sure these tests
  # (which are also in the main tests) still pass
  describe "product family page" do
    before do
      @product_family = @website.product_families.first
      @multiple_parent = FactoryGirl.create(:product_family, brand: @website.brand)
      2.times { FactoryGirl.create(:product_family_with_products, brand: @website.brand, parent_id: @multiple_parent.id)}
      @single_parent = FactoryGirl.create(:product_family, brand: @website.brand)
      FactoryGirl.create(:product_family_with_products, brand: @website.brand, parent_id: @single_parent.id, products_count: 1)
      FactoryGirl.create(:product_family, brand: @website.brand, parent_id: @single_parent.id)
      visit products_url(locale: I18n.default_locale, host: @website.url)
    end

    it "/products should redirect to products family page" do 
      current_path.must_equal product_families_path(locale: I18n.default_locale)
    end 

    it "should not link to full line where no child families exist" do
      page.wont_have_link I18n.t('view_full_line'), href: product_family_path(@product_family, locale: I18n.default_locale)
    end

    it "should link to full line where child families exist" do
      page.must_have_link I18n.t('view_full_line'), href: product_family_path(@multiple_parent, locale: I18n.default_locale)
    end

    it "should not link to full line for a family with one product in one sub-family" do
      page.wont_have_link I18n.t('view_full_line'), href: product_family_path(@single_parent, locale: I18n.default_locale)
    end
  end

  describe "XML for old-school demos" do
    it "should respond" do
      @product = @website.products.first
      @attachment = FactoryGirl.create(:product_attachment, songlist_tag: "Foo")
      visit "/#{I18n.default_locale}/products/songlist/#{@attachment.songlist_tag}.xml"
      page.must_have_xpath("//songs")
    end
  end

  describe "support page" do
    before do
      visit support_url(locale: I18n.default_locale, host: @website.url)
    end

    it "should require the country on the contact form" do
      message_count = ContactMessage.count
      page.must_have_content "Country (required)"
      select ContactMessage.subjects.last[0], from: "contact_message_subject"
      fill_in "contact_message_name", with: "Joe"
      fill_in "contact_message_email", with: "joe@joe.com"
      fill_in "contact_message_message", with: "Hi Dean. How are you?"
      click_on("submit")
      page.must_have_content("Country can't be blank")
      ContactMessage.count.wont_equal(message_count + 1)
    end
  end

end