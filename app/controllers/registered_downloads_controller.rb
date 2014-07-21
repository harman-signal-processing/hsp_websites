class RegisteredDownloadsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :load_registered_download_and_set_layout
  layout :set_layout
  
  # GET /:registered_download_url
  # POST /:registered_download_url/register
  def register
    @download_registration = DownloadRegistration.new(subscribe: true, registered_download: @registered_download)
    if params[:code]
      @download_registration.code_you_received = params[:code]
    end
    if request.post?
      params[:download_registration][:registered_download_id] = @registered_download.id
      @download_registration = DownloadRegistration.new(params[:download_registration])
      if @download_registration.save
        redirect_to confirm_download_registration_path(@registered_download.url) and return
      end
    end
  end
  
  def confirmation
  end

  # GET /:registered_download_url/get_it/:download_code
  def show
    @download_registration = DownloadRegistration.where(registered_download_id: @registered_download.id, download_code: params[:download_code]).first
    if @download_registration
      if @download_registration.download_count.to_i >= @registered_download.per_download_limit.to_i
        download_error("Download attempts exceeded limit")
      end
    else
      download_error("Invalid code.")
    end
  end

  # GET /:registered_download_url/downloadr/:download_code
  def download
    @download_registration = DownloadRegistration.where(registered_download_id: @registered_download.id, download_code: params[:download_code]).first
    if @download_registration
      if @download_registration.download_count.to_i >= @registered_download.per_download_limit.to_i
        download_error("Download attempts exceeded limit")
      else
        # send_file(@registered_download.protected_software.path, 
        #   type: @registered_download.protected_software_content_type,
        #   filename: @registered_download.protected_software_file_name)
        redirect_to @registered_download.protected_software.expiring_url
        @download_registration.download_count ||= 0
        @download_registration.download_count += 1
        @download_registration.save!
      end
    else
      download_error("Invalid code.")
    end
  end
  
  private
  
  # error page
  def download_error(msg="Invalid code.")
    @message = msg
    render action: "download_error", layout: false and return
  end

  def load_registered_download_and_set_layout
    @registered_download = RegisteredDownload.where(url: params[:registered_download_url], brand_id: website.brand_id).first
    unless @registered_download
      download_error("Sorry, I couldn't find that file. Check the URL")
    end
  end
  
  def set_layout
    if @registered_download 
      fn = @registered_download.html_layout_filename.to_s
      unless File.exist?(fn)
        @registered_download.save_templates_to_filesystem
      end
      fn
    else
      super
    end
  end

end
