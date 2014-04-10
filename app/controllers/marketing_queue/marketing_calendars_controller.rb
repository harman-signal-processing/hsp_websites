class MarketingQueue::MarketingCalendarsController < MarketingQueueController
	layout "marketing_queue"

	def index
		@marketing_calendar = MarketingCalendar.new
		@marketing_calendars = MarketingCalendar.order("UPPER(name)")
	end

	def show
		@marketing_calendar = MarketingCalendar.find(params[:id])
		@start_on = 7.days.ago.beginning_of_month
		@end_on = @start_on.advance(months: 5).end_of_month

		@marketing_projects = @marketing_calendar.marketing_projects.where("event_start_on >= ? OR event_end_on <= ?", @start_on, @end_on)

		if params[:brand_id]
			@brand = Brand.find(params[:brand_id])
			@marketing_project = @marketing_projects.where(brand_id: @brand.id)
		end

    respond_to do |format|
      format.html 
      format.xml { render xml: @marketing_projects }
      format.json { render json: @marketing_projects.order("UPPER(name)") }
    end
	end

	def create
		@marketing_calendar = MarketingCalendar.new(params[:marketing_calendar])
		if @marketing_calendar.save
			redirect_to [:marketing_queue, @marketing_calendar], notice: "The calendar was created. To add calendar items, create/edit projects and select '#{@marketing_calendar.name}' from the calendar selection."
		else
			index
			render action: 'index'
		end
	end
end