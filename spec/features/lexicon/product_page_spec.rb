require "rails_helper"

feature "Lexicon product page" do

  before :all do
    @brand = FactoryGirl.create(:lexicon_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @brand)
    @product = @website.products.first
    @software = FactoryGirl.create(:software, brand: @brand)
    @product.product_softwares << FactoryGirl.create(:product_software, software: @software, product: @product)
    @product.features_tab_name = "Culture"
    @product.features = "This is content for the features"
    @product.demo_link = 'http://demo.lvh.me/download/the/demo/form'
    @product.save
    @promo = FactoryGirl.create(:promotion)
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @promo, product: @product)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  before :each do
    allow_any_instance_of(Brand).to receive(:main_tabs).and_return("description|extended_description|features|specifications|reviews|downloads_and_docs")

    visit product_path(id: @product)
  end

  scenario "should call features tab Culture sometimes" do
    expect(page).to have_link "Culture"
  end

  scenario "should have a tab named Overview" do
    expect(page).to have_link "Overview"
  end

  scenario "should have a demo download link" do
    expect(page).to have_xpath("//a[@href='#{@product.demo_link}']")
  end

  scenario "should link to related current promotion" do
    expect(page).to have_link @promo.name
  end

end
