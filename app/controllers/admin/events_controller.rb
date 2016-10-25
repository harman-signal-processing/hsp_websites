class Admin::EventsController < AdminController
  before_filter :initialize_event, only: :create
  load_and_authorize_resource

  # GET /admin/events
  # GET /admin/events.xml
  def index
    # @events = @events.where(brand_id: website.brand_id).order("post_on DESC")
    @search = website.brand.events.ransack(params[:q])
    @events = @search.result
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @events }
    end
  end

  # GET /admin/event/1
  # GET /admin/event/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @event }
    end
  end

  # GET /admin/events/new
  # GET /admin/events/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @event }
    end
  end

  # GET /admin/event/1/edit
  def edit
  end

  # POST /admin/event
  # POST /admin/event.xml
  def create
    @event.brand = website.brand
    respond_to do |format|
      if @event.save
        format.html { redirect_to([:admin, @event], notice: 'Event was successfully created.') }
        format.xml  { render xml: @event, status: :created, location: @event }
        website.add_log(user: current_user, action: "Created event: #{@event.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/event/1
  # PUT /admin/event/1.xml
  def update
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to([:admin, @event], notice: 'Event was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated event: #{@event.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete banner
  def delete_image
    @event = Event.find(params[:id])
    @event.update_attributes(image: nil)
    respond_to do |format|
      format.html { redirect_to(admin_event_path(@event), notice: "Banner was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted banner image from get started event: #{@event.name}")
  end


  # DELETE /admin/event/1
  # DELETE /admin/event/1.xml
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted event: #{@event.name}")
  end

  private

  def initialize_event
    @event = Event.new(event_params)
  end

  def event_params
    params.require(:event).permit!
  end
end
