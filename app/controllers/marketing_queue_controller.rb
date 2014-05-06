class MarketingQueueController < ApplicationController
  layout "marketing_queue"
  skip_before_filter :miniprofiler
  before_filter :force_english
  before_filter :authenticate_marketing_queue_user!
  before_filter :build_search
  
  def index
  	@newest_projects = MarketingProject.newest.limit(6)
  	@ending_projects = MarketingProject.ending.limit(6)
		@brands_projects_summary = { brands: Brand.where(queue: true).order("UPPER(name)").all.map{|b| {label: b.name, value: b.open_marketing_projects.count}}}
    @unassigned_tasks = MarketingTask.unassigned.order("created_at ASC")

    @start_on = 15.days.ago.beginning_of_month
    @end_on = @start_on.advance(months: 5).end_of_month

  end

  def staff_meeting  	
    @active_brands = []
    @sleeper_brands = []

    Brand.where(queue: true).order("UPPER(name)").each do |brand|
      if brand.non_project_tasks_for_staff_meeting.count > 0 || brand.projects_for_staff_meeting.count > 0 
        @active_brands << brand 
      else
        @sleeper_brands << brand
      end
    end
  end

  # Shows a give user's activities--useful for managers to see who's doing what.
  def workload
    @user = User.find(params[:id])
  end

private

  def force_english
    I18n.locale = "en-US"
  end

  def build_search
    @q = MarketingProject.ransack(params[:q])
  end
  
end
