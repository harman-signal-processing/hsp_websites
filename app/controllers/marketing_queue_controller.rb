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

  # A dynamically generated bar for a gantt chart. Sure, you could do this
  # with CSS background colors, but then you'd have to customize your print
  # setup in your browser in order to see the bars on a printout.
  def bar
    brand = Brand.find(params[:brand_id])
    color = brand.color.present? ? brand.color : '#888'
    width = params[:width].to_i || 10
    height = params[:height].to_i || 10
    f = Magick::Image.new(width, height) { 
      self.background_color = color 
      self.format = "png"
    }
    send_data(f.to_blob, disposition: "inline", content_type: "image/png")
  end

private

  def force_english
    I18n.locale = "en-US"
  end

  def build_search
    @q = MarketingProject.ransack(params[:q])
  end
  
end
