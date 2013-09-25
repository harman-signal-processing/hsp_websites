require "test_helper"

describe "Marketing Queue Brands Integration Test" do

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

  it "should link to top high-profile projects on top"
  it "should link to remaining projects below"
  it "should list standalone tasks with quick actions"
  it "should have a calendar view of the projects"
  it "should have a gantt view of the projects"
  it "should have a link to show old projects and tasks"

end