class EventsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: :show

  def index
    @events = Event.all_for_website(website)

    respond_to do |format|
      format.html { render_template } # index.html.erb
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
