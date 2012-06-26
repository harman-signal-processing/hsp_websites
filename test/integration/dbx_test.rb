require "minitest_helper"

describe "dbx Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:dbx_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "dbx", brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  # Since dbx has different product family views, make sure these tests
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

end