require "rails_helper"

feature "Browse Products" do

  before :all do
    @website = FactoryBot.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "homepage" do

    # it "should redirect to the locale homepage" do
    #   skip "must_respond_with doesn't work in new MiniTest-rails"
    #   get root_url(host: @website.url)
    #   must_respond_with :redirect
    # end

    it "should have nav links" do
      visit root_path

      expect(page).to have_link "products", href: product_families_path(locale: I18n.default_locale)
    end

  end

  describe "product family page" do
    before :all do
      @product_family = FactoryBot.create(:product_family_with_products, brand: @website.brand, products_count: 5)
      @multiple_parent = FactoryBot.create(:product_family, brand: @website.brand)
      2.times { FactoryBot.create(:product_family_with_products, brand: @website.brand, parent_id: @multiple_parent.id)}
      @single_parent = FactoryBot.create(:product_family, brand: @website.brand)
      FactoryBot.create(:product_family_with_products, brand: @website.brand, parent_id: @single_parent.id, products_count: 1)
      FactoryBot.create(:product_family, brand: @website.brand, parent_id: @single_parent.id)
    end

    it "should not link to full line for a family with one product in one sub-family" do
      visit products_path(locale: I18n.default_locale)

      expect(page).not_to have_link I18n.t('view_full_line'), href: product_family_path(@single_parent, locale: I18n.default_locale)
    end

    it "should go directly to the product page where only one product exists in the family" do
      child_family = @single_parent.children_with_current_products(@website).first

      visit product_family_path(child_family, locale: I18n.default_locale)

      expect(current_path).to eq product_path(child_family.products.first, locale: I18n.default_locale)
    end

    it "should go directly to the product page where only one product exists in all the children" do
      child_family = @single_parent.children_with_current_products(@website).first

      visit product_family_path(@single_parent, locale: I18n.default_locale)

      expect(current_path).to eq product_path(child_family.products.first, locale: I18n.default_locale)
    end

    describe "comparisons" do
      before do
        allow_any_instance_of(Website).to receive(:show_comparisons).and_return("1")
        allow_any_instance_of(Brand).to receive(:show_comparisons).and_return("1")

        visit product_family_path(@product_family, locale: I18n.default_locale)
      end

      it "should handle error when comparing zero products" do
        click_on("Compare")

        expect(current_path).to eq product_families_path(locale: I18n.default_locale)
      end

      it "should handle error when comparing one product" do
        p = @product_family.products.first
        find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        click_on("Compare Selected Products")

        expect(current_path).to eq product_families_path(locale: I18n.default_locale)
      end

      it "should handle error when comparing more than four products" do
        @product_family.products.each do |p| # tick all for comparison
          find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        end
        click_on("Compare Selected Products")

        expect(current_path).to eq product_families_path(locale: I18n.default_locale)
      end

      it "should compare products" do
        @product_family.products[0,4].each do |p| # tick 4 for comparison
          find(:css, "#product_ids_[value='#{p.to_param}']").set(true)
        end
        click_on("Compare Selected Products")

        expect(current_path).to eq compare_products_path(locale: I18n.default_locale)
      end

    end

  end

  describe "discontinued product page" do
    before do
      @product = FactoryBot.create(:discontinued_product, brand: @website.brand)
    end

    it "should label the product as discontinued" do
      visit product_path(@product, locale: I18n.default_locale)

      expect(page).to have_content "discontinued"
    end

  end

end
