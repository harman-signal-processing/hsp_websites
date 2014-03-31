require "test_helper"

describe "US Reps Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
	    @rep1 = FactoryGirl.create(:us_rep)
	    @rep2 = FactoryGirl.create(:us_rep)
	    @region1 = FactoryGirl.create(:us_region)
	    @region2 = FactoryGirl.create(:us_region)
  end

  describe "rep index" do

  	before :each do 
	    FactoryGirl.create(:us_rep_region, us_rep: @rep1, brand: @website.brand, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, us_rep: @rep2, brand: @website.brand, us_region: @region2)
	  	visit us_reps_url(locale: I18n.default_locale, host: @website.url)
  	end

	  it "should have regions to choose from" do 
	  	within("select#us_region") do
	  		find("option[value='#{@region1.id}']").text.must_equal @region1.name
	  	end
	  end

	  it "should show the selected region" do 
	  	select(@region2.name, from: "us_region")
	  	click_button('submit')
	  	within("select#us_region") do
	  		find('option[selected]').text.must_equal @region2.name
	  	end
	  	page.must_have_content @rep2.name
	  	page.must_have_content @rep2.contact
	  	page.must_have_content @rep2.address
	  	page.must_have_content @rep2.city
	  	page.must_have_content @rep2.state
	  	page.must_have_content @rep2.zip
	  	page.must_have_content @rep2.phone
	  	page.must_have_content @rep2.fax
	  	page.must_have_content @rep2.email
	  end

	end

  describe "a brand dependent on another brand us reps" do

  	before :each do 
  		@master_brand = FactoryGirl.create(:brand)
  		@website.brand.us_sales_reps_from_brand_id = @master_brand.id 
  		@website.brand.save 

	    FactoryGirl.create(:us_rep_region, us_rep: @rep1, brand: @master_brand, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, us_rep: @rep2, brand: @master_brand, us_region: @region2)
	  	visit us_reps_url(locale: I18n.default_locale, host: @website.url)
  	end

	  it "should use regions from other brand" do 
	  	within("select#us_region") do
	  		find("option[value='#{@region1.id}']").text.must_equal @region1.name
	  	end
	  end

	  it "should show the selected region" do 
	  	select(@region2.name, from: "us_region")
	  	click_button('submit')
	  	within("select#us_region") do
	  		find('option[selected]').text.must_equal @region2.name
	  	end
	  	page.must_have_content @rep2.name
	  	page.must_have_content @rep2.contact
	  	page.must_have_content @rep2.address
	  	page.must_have_content @rep2.city
	  	page.must_have_content @rep2.state
	  	page.must_have_content @rep2.zip
	  	page.must_have_content @rep2.phone
	  	page.must_have_content @rep2.fax
	  	page.must_have_content @rep2.email
	  end

	end

end