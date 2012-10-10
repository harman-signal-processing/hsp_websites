require "minitest_helper"

describe "Toolkit Integration Test" do

  before do
    DatabaseCleaner.start
    @digitech = FactoryGirl.create(:digitech_brand)
    @digitech_site = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @digitech)
    @lexicon  = FactoryGirl.create(:lexicon_brand)
    @lexicon_site = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @lexicon)
    @bss = FactoryGirl.create(:bss_brand)
    # @bss_site = FactoryGirl.create(:website_with_products, folder: "bss", brand: @bss)
    @dbx = FactoryGirl.create(:dbx_brand)
    @dbx_site = FactoryGirl.create(:website_with_products, folder: "dbx", brand: @dbx)
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