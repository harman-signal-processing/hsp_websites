require "test_helper"

describe "Marketing Queue Integration Test" do

	before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    setup_toolkit_brands
    @host = HarmanSignalProcessingWebsite::Application.config.queue_url 
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "Homepage" do 
    it "should link to newest projects"
  end

  describe "Dashboard (lower half of homepage)" do 
    it "should show my assigned tasks"
    it "should show projects I'm managing"
  end

  describe "Queue admin logged in" do
    it "should have a top nav item for running the weekly staff meeting" 
    it "should link to unassigned tasks if the user is an admin"
    it "should show worker allocations"
  end

end