class Admin::DownloadRegistrationsController < AdminController
  before_action :initialize_download_registration, only: :create
  load_and_authorize_resource
  
  # GET /download_registrations
  # GET /download_registrations.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @download_registrations }
    end
  end

  # GET /download_registrations/1
  # GET /download_registrations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @download_registration }
    end
  end

  # GET /download_registrations/new
  # GET /download_registrations/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @download_registration }
    end
  end

  # GET /download_registrations/1/edit
  def edit
  end

  # POST /download_registrations
  # POST /download_registrations.xml
  def create
    respond_to do |format|
      if @download_registration.save
        format.html { redirect_to([:admin, @download_registration.registered_download], notice: 'Download registration was successfully created.') }
        format.xml  { render xml: @download_registration, status: :created, location: @download_registration }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @download_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /download_registrations/1
  # PUT /download_registrations/1.xml
  def update
    respond_to do |format|
      if @download_registration.update(download_registration_params)
        format.html { redirect_to([:admin, @download_registration.registered_download], notice: 'Download registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @download_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /download_registrations/1
  # DELETE /download_registrations/1.xml
  def destroy
    @download_registration.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @download_registration.registered_download]) }
      format.xml  { head :ok }
    end
  end
  
  # GET /download_registration/1/reset_and_resend
  # Re-sends the download notice for this registration
  def reset_and_resend
    @download_registration.update(download_count: 0)
    @download_registration.deliver_download_code
    @msg = "Message to #{@download_registration.first_name} is on its way."
    respond_to do |format|
      format.html { redirect_to [:admin, @download_registration.registered_download], notice: @msg}
      format.js
    end
  end

  private

  def initialize_download_registration
    @download_registration = DownloadRegistration.new(download_registration_params)
  end

  def download_registration_params
    params.require(:download_registration).permit!
  end
end
