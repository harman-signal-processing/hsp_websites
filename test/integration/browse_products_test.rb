require "test_helper"

describe "Browse Products Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  after :each do
    DatabaseCleaner.clean
  end
  
  describe "homepage" do

    it "should redirect to the locale homepage" do
      skip "must_respons_with doesn't work in new MiniTest-rails"
      get root_url(host: @website.url)
      must_respond_with :redirect
    end

    it "should have nav links" do
      visit root_url(host: @website.url)
      page.must_have_link "products", href: product_families_path(locale: I18n.default_locale)
    end
    
  end

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

    it "should go directly to the product page where only one product exists in the family" do
      child_family = @single_parent.children_with_current_products(@website).first
      visit product_family_url(child_family, locale: I18n.default_locale, host: @website.url)
      current_path.must_equal product_path(child_family.products.first, locale: I18n.default_locale)
    end

    it "should go directly to the product page where only one product exists in all the children" do
      child_family = @single_parent.children_with_current_products(@website).first
      visit product_family_url(@single_parent, locale: I18n.default_locale, host: @website.url)
      current_path.must_equal product_path(child_family.products.first, locale: I18n.default_locale)
    end

    describe "comparisons" do
      before do 
        Website.any_instance.stubs(:show_comparisons).returns("1")
        visit product_family_url(@product_family, locale: I18n.default_locale, host: @website.url)  
      end

      it "should handle error when comparing zero products" do
        click_on("Compare")
        page.current_path.must_equal product_families_path(locale: I18n.default_locale)
      end

      it "should handle error when comparing one product" do
        p = @product_family.products.first
        find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        click_on("Compare Selected Products")
        page.current_path.must_equal product_families_path(locale: I18n.default_locale)
      end

      it "should handle error when comparing more than four products" do
        @product_family.products.each do |p| # tick all for comparison
          find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        end
        click_on("Compare Selected Products")
        page.current_path.must_equal product_families_path(locale: I18n.default_locale)
      end

      it "should compare products" do
        @product_family.products[0,4].each do |p| # tick 4 for comparison
          find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        end
        click_on("Compare Selected Products")
        page.current_path.must_equal compare_products_path(locale: I18n.default_locale)
      end

    end

  end

  describe "discontinued product page" do
    before do
      @product = FactoryGirl.create(:discontinued_product, brand: @website.brand)
    end

    it "should use the discontinued page layout" do 
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.must_have_content "discontinued"
    end

    it "should link to attached documents" do
      @product.product_documents << FactoryGirl.create(:product_document, product: @product)
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.must_have_link @product.product_documents.first.name, href: @product.product_documents.first.document.url
    end

    it "should have thumbnail images" do
      @product.product_attachments << FactoryGirl.create(:product_attachment, product: @product)
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.must_have_xpath("//img[@src='#{@product.product_attachments.first.product_attachment.url(:small)}']")
    end

    it "should link to software" do
      software = FactoryGirl.create(:software)
      @product.product_softwares << FactoryGirl.create(:product_software, product: @product, software: software)
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.must_have_link software.formatted_name, href: software_path(software, locale: I18n.default_locale) 
    end

  end
 
end