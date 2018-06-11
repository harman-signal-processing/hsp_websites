class SoftwaresController < ApplicationController
  before_action :set_locale, except: [:activate]

  # GET /softwares
  # GET /softwares.xml
  def index
    @discontinued_products = Product.discontinued(website, [:softwares])
    @current_products = Product.all_for_website(website, [:softwares]) - @discontinued_products
    respond_to do |format|
      format.html { render_template } # index.html.erb
    end
  end

  # GET /softwares/1
  # GET /softwares/1.xml
  def show
    @software = Software.find(params[:id])
    # unless @software.brand == website.brand
    #   redirect_to softwares_path and return
    # end
    if @software.active? || can?(:manage, @software) || (@software.replaced_by && @software.replaced_by.is_a?(Software))
      @page_title = @software.formatted_name
      respond_to do |format|
        format.html {
          if @software.has_additional_info?
            if !@software.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "softwares", "#{@software.layout_class}.html.erb"))
              render template: "#{website.folder}/softwares/#{@software.layout_class}", layout: set_layout
            else
              render_template
            end
          else
            redirect_to download_software_path(@software, locale: I18n.locale), status: :moved_permanently and return false
          end
        }
        # format.xml  { render xml: @software }
      end
    else
      redirect_to softwares_path and return
    end
  end

  # Custom route allows us to increment the counter before
  # sending the file to the user
  # GET /download/1
  def download
    @software = Software.find(params[:id])
    # unless @software.brand == website.brand
    #   redirect_to softwares_path and return
    # end
    @software.increment_count
    if !@software.link.blank?
      @software.link = "https://" + @software.link unless @software.link.match(/^http/)
      redirect_to @software.link, status: :moved_permanently and return
    else
      # Used to use send_file to take advantage of nginx caching, but now we just
      # redirect to S3/Cloudfront url.
      if @software.ware_file_name.to_s.match?(/\.mu3$/i)
        data = open(@software.ware.url)
        send_data data.read,
          filename: @software.ware_file_name,
          content_type: @software.ware_content_type,
          disposition: :attachment
      else
        redirect_to @software.ware.url, status: :moved_permanently
      end
    end
  end

  # Software activation. Pass in the name of the software and the challenge phrase,
  # generate an activation key. This all started with the MPX-L. To use this for
  # other software, edit the software in the admin area and provide the
  # "activation_name" (for the URL) and the "multipliers".
  #
  # If you want to use a special layout (perhaps without all the site navigation),
  # then create a layout here: app/views/(brand_folder)/layouts/software_activation.html.erb
  #
  def activate
    software_name = params[:software_name]
    challenge = params[:challenge]
    if software_name.blank? || challenge.blank?
      render plain: "Incomplete information. Please try again." and return
    else
      software = Software.where(activation_name: software_name).first
      @activation = SoftwareActivation.create(software: software, challenge: challenge)
      brand_layout = "#{website.folder}/layouts/software_activation"
      use_layout = File.exist?(Rails.root.join("app", "views", "#{brand_layout}.html.erb")) ? "/#{brand_layout}" : true
      render_template layout: use_layout
    end
  end

end
