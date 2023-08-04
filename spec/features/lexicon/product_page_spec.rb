require "rails_helper"

feature "Lexicon product page" do

  before :all do
    @brand = FactoryBot.create(:lexicon_brand)
    @website = FactoryBot.create(:website_with_products, folder: "lexicon", brand: @brand)
    @product = @website.products.first
    @software = FactoryBot.create(:software, brand: @brand)
    @product.product_softwares << FactoryBot.create(:product_software, software: @software, product: @product)
    @product.features_tab_name = "Culture"
    @product.features = "This is content for the features"
    @product.demo_link = 'http://demo.lvh.me/download/the/demo/form'
    @product.save
    @promo = FactoryBot.create(:promotion)
    @product.product_promotions << FactoryBot.create(:product_promotion, promotion: @promo, product: @product)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  before :each do
    allow_any_instance_of(Brand).to receive(:main_tabs).and_return(%w(description extended_description features specifications reviews downloads_and_docs))
  end

  scenario "should call features tab Culture sometimes" do
    visit product_path(id: @product)
    expect(page).to have_link "Culture"
  end

  scenario "should have a tab named Overview" do
    visit product_path(id: @product)
    expect(page).to have_link "Overview"
  end

  scenario "should have a demo download link" do
    visit product_path(id: @product)
    expect(page).to have_xpath("//a[@href='#{@product.demo_link}']")
  end

  scenario "should link to related current promotion" do
    FactoryBot.create(:website_locale, website: @website, default: false, locale: "en-US")
    visit product_path(id: @product, locale: "en-US") + "?geo=us&geo_country=us"

    expect(page).to have_link @promo.name
  end

end
