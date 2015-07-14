require "rails_helper"

feature "Marketing Queue tasks" do

	before :all do
    setup_toolkit_brands
    @host = HarmanSignalProcessingWebsite::Application.config.queue_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  describe "Marketing staff actions" do
  	before do
      setup_and_login_queue_user
  		visit new_marketing_queue_marketing_task_path
  	end

    describe "Standalone tasks" do
    	it "should link to the new task form" do
        expect(page).to have_content "New Task"
        expect(current_path).to eq new_marketing_queue_marketing_task_path
    	end

      it "should not assign to others" do
        expect(page).not_to have_content "Worker"
        expect(page).not_to have_select "marketing_task_worker_id"
      end

      it "should require the task name" do
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        click_on "Create Task"

        expect(page).to have_content "can't be blank"
      end

      it "should offer to assign task to oneself" do
        fill_in :marketing_task_name, with: "Pet the dog"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        fill_in :marketing_task_creative_brief, with: "Make it cool."
        select @digitech.name, from: :marketing_task_brand_id
        check "marketing_task_assign_to_me"
        click_on "Create Task"

        expect(MarketingTask.last.worker_id).to eq @user.id
      end
    end

    #describe "Existing task" do
      # it "should mark complete"
      # it "should attach files"
      # it "should have thread of comments"
    #end
  end

  describe "Market manager actions" do
    before do
      setup_and_login_market_manager
      @project1 = FactoryGirl.create(:marketing_project, name: "Open DigiTech project", brand: @digitech)
      @project2 = FactoryGirl.create(:marketing_project, name: "Open dbx Project", brand: @dbx)
      @closed_project = FactoryGirl.create(:marketing_project, name: "Closed Project", due_on: 1.year.ago, event_end_on: 1.year.ago)
      visit new_marketing_queue_marketing_task_path
    end

    describe "Standalone tasks" do

      it "should offer a selection of all open projects" do
        fill_in :marketing_task_name, with: "Pet the dog"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        fill_in :marketing_task_creative_brief, with: "Make it cool."
        select @digitech.name, from: :marketing_task_brand_id
        select @project1.name, from: "marketing_task_marketing_project_id"
        click_on "Create Task"

        expect(MarketingTask.last.marketing_project_id).to eq @project1.id
      end

      it "should not show closed projects in the selection" do
        expect(page).to have_select "marketing_task_marketing_project_id"
        expect(page).not_to have_xpath "//select[@id='marketing_task_marketing_project_id']/option[@value='#{@closed_project.id}']"
      end

      # it "should filter the selection of open projects after selecting the brand"
      # it "should redirect to the selected project (if any) after creating the task"

      it "should not assign to others" do
        expect(page).not_to have_content "Worker"
        expect(page).not_to have_select "marketing_task_worker_id"
      end

      it "should not assign task to oneself if the box is not checked" do
        fill_in :marketing_task_name, with: "Pet the cat"
        fill_in :marketing_task_due_on, with: 2.weeks.from_now.to_s
        fill_in :marketing_task_creative_brief, with: "Make it cool."
        select @digitech.name, from: :marketing_task_brand_id
        uncheck "marketing_task_assign_to_me"
        click_on "Create Task"

        expect(MarketingTask.last.worker_id).not_to eq @user.id
      end

    end
  end

  describe "Admin user actions" do
    before do
      setup_and_login_queue_admin
      visit new_marketing_queue_marketing_task_path
    end

    describe "Standalone tasks" do
      it "should be able to assign the worker" do
        expect(page).to have_content "Worker"
        expect(page).to have_select "marketing_task_worker_id"
      end

      it "should not offer to assign to oneself" do # (since self will be available in the dropdown)
        expect(page).not_to have_content "Assign to me"
      end
    end
  end

end
