require "rails_helper"

feature "XML rendered for old-school flash demos" do

  before do
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  scenario "should respond" do
    @product = @website.products.first
    @attachment = FactoryGirl.create(:product_attachment, songlist_tag: "Foo")

    visit "/#{I18n.default_locale}/products/songlist/#{@attachment.songlist_tag}.xml"

    expect(page).to have_xpath("//songs")
  end

end
