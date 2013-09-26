require "test_helper"

describe "Marketing Tasks Integration Test" do

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

  #
  # General users who are part of the marketing staff
  #
  describe "Marketing staff actions" do 
  	before do
      setup_and_login_queue_user
  		visit new_marketing_queue_marketing_task_url(host: @host)
  	end

    describe "Standalone tasks" do
    	it "should link to the new task form" do 
    		must_have_content "New Task"
        current_path.must_equal new_marketing_queue_marketing_task_path
    	end

      it "should not assign to others" do 
        wont_have_content "Worker"
        wont_have_select "marketing_task_worker_id"
      end

      it "should require the task name" do
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        click_on "Create Marketing task"
        must_have_content "can't be blank"
      end

      it "should offer to assign task to oneself" do
        fill_in :marketing_task_name, with: "Pet the dog"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        select @digitech.name, from: :marketing_task_brand_id
        must_have_content "Assign to me"
        check "marketing_task_assign_to_me"
        click_on "Create Marketing task"
        MarketingTask.last.worker_id.must_equal @user.id
      end
    end

    describe "Existing task" do 
      # it "should mark complete"
      # it "should attach files"
      # it "should have thread of comments"
    end
  end

  #
  # Market managers
  #
  describe "Market manager actions" do 
    before do
      setup_and_login_market_manager
      @project1 = FactoryGirl.create(:marketing_project, name: "Open DigiTech project", brand: @digitech)
      @project2 = FactoryGirl.create(:marketing_project, name: "Open dbx Project", brand: @dbx)
      @closed_project = FactoryGirl.create(:marketing_project, name: "Closed Project", due_on: 1.year.ago, event_end_on: 1.year.ago)
      visit new_marketing_queue_marketing_task_url(host: @host)
    end

    describe "Standalone tasks" do
      it "should link to the new task form" do 
        must_have_content "New Task"
        current_path.must_equal new_marketing_queue_marketing_task_path
      end

      it "should offer a selection of all open projects" do
        fill_in :marketing_task_name, with: "Pet the dog"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        select @digitech.name, from: :marketing_task_brand_id
        must_have_select "marketing_task_marketing_project_id"
        select @project1.name, from: "marketing_task_marketing_project_id"
        click_on "Create Marketing task"
        MarketingTask.last.marketing_project_id.must_equal @project1.id
      end

      it "should not show closed projects in the selection" do
        must_have_select "marketing_task_marketing_project_id"
        wont_have_xpath "//select[@id='marketing_task_marketing_project_id']/option[@value='#{@closed_project.id}']"
      end

      # it "should filter the selection of open projects after selecting the brand"
      # it "should redirect to the selected project (if any) after creating the task"

      it "should not assign to others" do 
        wont_have_content "Worker"
        wont_have_select "marketing_task_worker_id"
      end

      it "should offer to assign task to oneself" do
        fill_in :marketing_task_name, with: "Pet the dog"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        select @digitech.name, from: :marketing_task_brand_id
        must_have_content "Assign to me"
        check "marketing_task_assign_to_me"
        click_on "Create Marketing task"
        MarketingTask.last.worker_id.must_equal @user.id
      end
    end
  end

  #
  # Marketing queue administrator
  #
  describe "Admin user actions" do 
    before do
      setup_and_login_queue_admin
      visit new_marketing_queue_marketing_task_url(host: @host)
    end

    describe "Standalone tasks" do 
      it "should be able to assign the worker" do 
        must_have_content "Worker"
        must_have_select "marketing_task_worker_id"
      end

      it "should not offer to assign to oneself" do # (since self will be available in the dropdown)
        wont_have_content "Assign to me"
      end
    end      

  end

end