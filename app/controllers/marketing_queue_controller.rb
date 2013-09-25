class MarketingQueueController < ApplicationController
  layout "marketing_queue"
  skip_before_filter :miniprofiler
  before_filter :authenticate_marketing_queue_user!
  before_filter :build_search
  
  def index
  	@newest_projects = MarketingProject.newest.limit(6)
  	@ending_projects = MarketingProject.ending.limit(6)
		@brands_projects_summary = { brands: Brand.where(queue: true).order("UPPER(name)").all.map{|b| {label: b.name, value: b.open_marketing_projects.count}}}
  end

  def staff_meeting  	
    @active_brands = []
    @sleeper_brands = []

    Brand.where(queue: true).order("UPPER(name)").each do |brand|
      if brand.marketing_tasks.where(marketing_project_id: nil, completed_at: nil).count > 0 || brand.open_marketing_projects.count > 0 
        @active_brands << brand 
      else
        @sleeper_brands << brand
      end
    end
  end

  # Shows a give user's activities--useful for managers to see who's doing what.
  def workload
    @user = User.find(params[:id])
    @nameses = "#{@user.name}'s"
    #render text: "Hi"
  end

private

  def build_search
    @q = MarketingProject.ransack(params[:q])
  end
  
end
