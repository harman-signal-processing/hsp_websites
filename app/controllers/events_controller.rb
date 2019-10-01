class EventsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  def index
    all_events = Event.current_and_upcoming.
      where(brand_id: website.brand_id).
      where("start_on < ?", 6.months.from_now)
    #@events = filter_by_locale(all_events)
    @events = all_events

    @banner_event = nil
    banner_events = @events.where.not(image_file_name: [nil, ""])
    if banner_events.size > 0
      @banner_event = banner_events.first
    end

    respond_to do |format|
      format.html {
        if @events.length > 0
          render_template
        else
          redirect_to "#{ENV['PRO_SITE_URL']}/events" and return false
        end
      }
      format.xml  { render xml: @events }
    end
  end

  def show
    if !website.events.include?(@event) || !@event.active?
      redirect_to events_path and return false
    end
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @event }
    end
  end

  protected

  def ensure_best_url
    @event = Event.where(cached_slug: params[:id]).first || Event.find(params[:id])
    # redirect_to @event, status: :moved_permanently unless @news.friendly_id_status.best?
  end
end
