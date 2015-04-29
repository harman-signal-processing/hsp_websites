require "rails_helper"

feature "DOD brand layout" do

  before :each do
    @brand = FactoryGirl.create(:dod_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "dod", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  scenario "correct layout is used" do
    visit root_path

    expect(page).to have_xpath("//body[@data-brand='#{@brand.name}']")
  end
end
