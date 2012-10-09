require "minitest_helper"

describe "Toolkit Integration Test" do

  before do
    DatabaseCleaner.start
    @website = FactoryGirl.create(:website_with_products)
    @host = "test.toolkit.lvh.me"
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
  end
  
  describe "homepage" do
  	it "should use the toolkit layout" do
  		visit root_url(host: @host)
  		must_have_content "Marketing Toolkit"
  	end
  end

  describe "devise user accounts" do
  	it "should use the toolkit layout" do
  		visit new_user_session_url(host: @host)
  		must_have_content "Marketing Toolkit"
  	end
  end

end