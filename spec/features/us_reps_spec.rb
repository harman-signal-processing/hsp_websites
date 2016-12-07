require "rails_helper"

feature "US Reps" do

  before :all do
    @website = FactoryGirl.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @rep1 = FactoryGirl.create(:us_rep)
    @rep2 = FactoryGirl.create(:us_rep)
    @region1 = FactoryGirl.create(:us_region)
    @region2 = FactoryGirl.create(:us_region)
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "rep index" do

  	before do
	    FactoryGirl.create(:us_rep_region, us_rep: @rep1, brand: @website.brand, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, us_rep: @rep2, brand: @website.brand, us_region: @region2)

	  	visit us_reps_path(locale: I18n.default_locale)
  	end

	  it "should have regions to choose from" do
      expect(page).to have_xpath("//select[@id='us_region']/option[@value='#{@region1.id}']", text: @region1.name)
	  end

	  it "should show the selected region" do
	  	select(@region2.name, from: "us_region")
	  	click_button('submit')

      expect(page).to have_xpath("//select[@id='us_region']/option[@selected]", text: @region2.name)
	  	expect(page).to have_content @rep2.name
	  	expect(page).to have_content @rep2.contact
	  	expect(page).to have_content @rep2.address
	  	expect(page).to have_content @rep2.city
	  	expect(page).to have_content @rep2.state
	  	expect(page).to have_content @rep2.zip
	  	expect(page).to have_content @rep2.phone
	  	expect(page).to have_content @rep2.fax
	  	expect(page).to have_content @rep2.email
	  end

	end

  describe "a brand dependent on another brand us reps" do

  	before do
  		@master_brand = FactoryGirl.create(:brand)
  		@website.brand.us_sales_reps_from_brand_id = @master_brand.id
  		@website.brand.save

	    FactoryGirl.create(:us_rep_region, us_rep: @rep1, brand: @master_brand, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, us_rep: @rep2, brand: @master_brand, us_region: @region2)
	  	visit us_reps_path(locale: I18n.default_locale)
  	end

	  it "should use regions from other brand" do
      expect(page).to have_xpath("//select[@id='us_region']/option[@value='#{@region1.id}']", text: @region1.name)
	  end

	  it "should show the selected region" do
	  	select(@region2.name, from: "us_region")
	  	click_button('submit')

      expect(page).to have_xpath("//select[@id='us_region']/option[@selected]", text: @region2.name)
	  	expect(page).to have_content @rep2.name
	  	expect(page).to have_content @rep2.contact
	  	expect(page).to have_content @rep2.address
	  	expect(page).to have_content @rep2.city
	  	expect(page).to have_content @rep2.state
	  	expect(page).to have_content @rep2.zip
	  	expect(page).to have_content @rep2.phone
	  	expect(page).to have_content @rep2.fax
	  	expect(page).to have_content @rep2.email
	  end

	end

  describe "a brand not-dependent on another brand us reps" do

  	before do
      @brand1 = @website.brand
  		@brand2 = FactoryGirl.create(:brand)

	    FactoryGirl.create(:us_rep_region, us_rep: @rep1, brand: @brand1, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, us_rep: @rep2, brand: @brand2, us_region: @region1)
	    FactoryGirl.create(:us_rep_region, brand: @brand2, us_region: @region2)
	  	visit us_reps_path(locale: I18n.default_locale)
  	end

	  it "should not use regions from other brand" do
      expect(page).not_to have_xpath("//select[@id='us_region']/option[@value='#{@region2.id}']", text: @region2.name)
	  end

	  it "should show the reps only for the site's brand not the other brand" do
	  	select(@region1.name, from: "us_region")
	  	click_button('submit')

      expect(page).to have_xpath("//select[@id='us_region']/option[@selected]", text: @region1.name)
	  	expect(page).to have_content @rep1.name
	  	expect(page).not_to have_content @rep2.name
	  end

	end

end
