require "rails_helper"

feature "dbx brand layout" do

  before :each do
    @brand = FactoryBot.create(:dbx_brand)
    @website = FactoryBot.create(:website, folder: "dbx", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  scenario "correct layout is used" do
    visit root_path

    expect(page).to have_xpath("//body[@data-brand='#{@brand.name}']")
  end

end
