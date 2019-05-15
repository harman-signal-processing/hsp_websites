require 'csv'
class Admin::RegisteredDownloadsController < AdminController
  before_action :initialize_registered_download, only: :create
  load_and_authorize_resource

  # GET /registered_downloads
  # GET /registered_downloads.xml
  def index
    @registered_downloads = @registered_downloads.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @registered_downloads }
    end
  end

  # GET /registered_downloads/1
  # GET /registered_downloads/1.xml
  def show
    @search = @registered_download.download_registrations.ransack(params[:q])
    if params[:q]
      @download_registrations = @search.result(distinct: true).paginate(page: params[:page], per_page: 100)
    else
      @download_registrations = @registered_download.download_registrations.paginate(page: params[:page], per_page: 100)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render xml: @registered_download.download_registrations  }
      format.xls {
        send_data(@registered_download.download_registrations.to_a.to_xls(
          headers: @registered_download.headers_for_export,
          columns: @registered_download.columns_for_export),
        filename: "#{@registered_download.name.gsub(/\s/,"-")}.xls")
      }
    end
  end

  # GET /registered_downloads/new
  # GET /registered_downloads/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @registered_download }
    end
  end

  # GET /registered_downloads/1/edit
  def edit
  end

  # POST /registered_downloads
  # POST /registered_downloads.xml
  def create
    @registered_download.brand = website.brand
    respond_to do |format|
      if @registered_download.save
        format.html { redirect_to([:admin, @registered_download], notice: 'Registered download was successfully created.') }
        format.xml  { render xml: @registered_download, status: :created, location: @registered_download }
        website.add_log(user: current_user, action: "Created registered download: #{@registered_download.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @registered_download.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /registered_downloads/1
  # PUT /registered_downloads/1.xml
  def update
    respond_to do |format|
      if @registered_download.update_attributes(registered_download_params)
        format.html { redirect_to([:admin, @registered_download], notice: 'Registered download was successfully updated. IF YOU NEED TO MAKE MORE CHANGES, CLICK "Edit" BELOW--NOT "Back"') }
        format.xml  { head :ok }
        format.js {
          @registered_download.update_attributes(protected_software: nil)
        }
        website.add_log(user: current_user, action: "Updated registered download: #{@registered_download.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @registered_download.errors, status: :unprocessable_entity }
        format.js { render template: "admin/registered_downloads/update_error" }
      end
    end
  end

  # DELETE /registered_downloads/1
  # DELETE /registered_downloads/1.xml
  def destroy
    @registered_download.destroy
    respond_to do |format|
      format.html { redirect_to(admin_registered_downloads_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted registered download: #{@registered_download.name}")
  end

  # GET /registered_downloads/1/send_messages
  # Queues up the download messages for ALL associated registrations which
  # have not yet downlaoded the file.
  def send_messages
    @registered_download.send_messages_to_undownloaded
    respond_to do |format|
      format.html { redirect_to [:admin, @registered_download], notice: "Messages are being sent now..."}
      format.js
    end
    website.add_log(user: current_user, action: "Sent messages to registrants for #{@registered_download.name}")
  end

  private

  def initialize_registered_download
    @registered_download = RegisteredDownload.new(registered_download_params)
  end

  def registered_download_params
    params.require(:registered_download).permit!
  end
end
