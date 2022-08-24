class SupportController < ApplicationController
  include Distributors
  include ServiceCenters
  include Rsos

  before_action :set_locale
  skip_forgery_protection only: [
    :selected_downloads_by_product,
    :selected_downloads_by_type,
    :downloads_by_product,
    :downloads_by_type
  ]
#  caches_action :selected_downloads_by_product, :selected_downloads_by_type

  # Support home page
  def index
    @contact_message = ContactMessage.new
    @contact_message.require_country = true if require_country?
    if params[:product_id]
      if product = Product.find(params[:product_id])
        if url_matches?("lexicon") && !product.discontinued?
          redirect_to product_path(product, tab: "downloads_and_docs"), status: :moved_permanently and return
        else
          redirect_to product, status: :moved_permanently and return
        end
      end
    end
    render_template
  end

  def tech_support
    # if session['geo_usa']
      @contact_message = ContactMessage.new
      @contact_message.require_country = true if require_country?
    # else
      brand = @website.brand.name.downcase
      brand = "axys tunnel by jbl" if brand == "duran audio"
      country_code = clean_country_code
      @distributors = get_international_distributors(brand, country_code)
    # end
    render_template
  end

  def repairs
      brand = @website.brand.name.downcase
      brand = "axys tunnel by jbl" if brand == "duran audio"

    if session['geo_usa']
      # state = params[:state].presence || helpers.user_usa_state_code.to_s || "any"
      # state = params[:state].presence || "any"
      state = params[:state].presence || ""
      @service_centers = get_service_centers(brand, state)
    else
      country_code = clean_country_code
      @distributors = get_international_distributors(brand, country_code)
    end
    render_template
  end

  def rsos
    country_code = clean_country_code
    @rsos = get_rsos(country_code)
    render_template
  end

  def safety
    @product_families = ProductFamily.top_level_for(website)
    render_template
  end

  # Routes to /:locale/training
  def training
    @page_title = "#{website.brand.name} Training"
    @product_training_modules = website.training_modules(module_type: 'product')
    @software_training_modules = website.training_modules(module_type: 'software')
    render_template
  end

  # Warranty registration form
  def warranty_registration
    # 2022-08 Getting lots of geniuses trying to POST JSON here. Let's just give them an error without much info:
    if request.format.json?
      raise ActionController::UnpermittedParameters.new ["not allowed"]
    end
    if request.post?
      @warranty_registration = WarrantyRegistration.new(warranty_registration_params)
      @warranty_registration.brand_id = website.brand_id
      if @warranty_registration.valid? && verify_recaptcha(model: @warranty_registration, secret_key: website.recaptcha_private_key)
        @warranty_registration.save
        if @warranty_registration.product && @warranty_registration.product.get_started_page.present?
          cookies[@warranty_registration.product.get_started_page.cookie_name] = { value: @warranty_registration.id, expires: 10.years.from_now }
          redirect_path = get_started_path(@warranty_registration.product.get_started_page)
        else
          redirect_path = support_path
        end
        redirect_to redirect_path, alert: t('blurbs.warranty_registration_success') and return false
      end
    else
      @warranty_registration = WarrantyRegistration.new(purchased_on: Date.yesterday, brand: website.brand)
      @warranty_registration.country = "United States" if params[:locale] =~ /\-US$/
      begin
        @warranty_registration.product = Product.find(params[:product_id]) if params[:product_id]
      rescue
        # problem auto-determining the product from the referring link, no big deal
      end
    end
    render_template
  end

  # The site's contact form
  # TODO: It would be smart to DRY up all the different contact form methods
  # (contact, parts, rma, catalog) into one action. Also, it makes sense to
  # follow REST and put these in their own controller.
  def contact
    @contact_message = ContactMessage.new do |c|
      c.require_country = true if require_country?
    end
    if request.post?
      @contact_message = ContactMessage.new(contact_message_params) do |c|
        c.brand = website.brand
        c.require_country = true if require_country?
        c.email_to = params[:contact_message][:email_to] if params[:contact_message][:email_to].present?
      end
      if verify_recaptcha(model: @contact_message, secret_key: website.recaptcha_private_key) && @contact_message.valid?
        @contact_message.save
        SiteMailer.delay.contact_form(@contact_message)
        redirect_to support_path, notice: t('blurbs.contact_form_thankyou') and return false
      end
    end
    @discontinued_products = Product.discontinued(website)
    render_template(action: "index")
  end

  # Parts request form
  def parts
    if session['geo_usa']
      @page_title = t('titles.part_request')
        # 4/2015 There have been problems with the Crown parts and RMA
        # forms. I'm temporarily removing the filter to redirect non-parts
        # brands so we can see if that is the problem...
      unless website.has_parts_form?
        website.add_log(user: User.default, action: "Parts form attempted, but redirected since brand doesn't support it.")
        #redirect_to support_path and return false
      end
      if request.post?
        @contact_message = ContactMessage.new(contact_message_params) do |c|
          c.message_type = 'part_request'
          c.brand = website.brand
        end

        if @contact_message.valid?
          @contact_message.save
          SiteMailer.delay.contact_form(@contact_message)
          redirect_to support_path, notice: t('blurbs.parts_request_thankyou') and return false
        end
      else
        @contact_message = ContactMessage.new(message_type: "part_request")
      end
    else
      brand = @website.brand.name.downcase
      brand = "axys tunnel by jbl" if brand == "duran audio"
      country_code = clean_country_code
      @distributors = get_international_distributors(brand, country_code)
    end
    render_template
  end

  # RMA request form
  def rma
    @page_title = t('titles.rma_request')
      # 4/2015 There have been problems with the Crown parts and RMA
      # forms. I'm temporarily removing the filter to redirect non-parts
      # brands so we can see if that is the problem...
    unless website.has_rma_form?
      website.add_log(user: User.default, action: "RMA attempted, but redirected since brand doesn't support it.")
      #redirect_to support_path and return false
    end

    if request.post?
      @contact_message = ContactMessage.new(contact_message_params) do |c|
        # Amx needs to split rma into repair or credit, all other brands use one rma type
        rma_message_type = params[:contact_message][:message_type] ? params[:contact_message][:message_type] : "rma_request"
        c.message_type = rma_message_type
        c.brand = website.brand
      end
      if @contact_message.valid?
        @contact_message.save
        SiteMailer.delay.contact_form(@contact_message)
        redirect_to support_path, notice: t('blurbs.rma_request_thankyou') and return false
      end
    else
      rma_message_type = params[:message_type] ? params[:message_type] : "rma_request"
      @contact_message = ContactMessage.new(message_type: rma_message_type)
    end
    render_template
  end

  def catalog_request
    @page_title = "DVD Catalog Request"
    @contact_message = ContactMessage.new(message_type: "catalog_request")
    if request.post?
      @contact_message = ContactMessage.new(contact_message_params) do |c|
        c.message_type = "catalog_request"
        c.brand = website.brand
      end
      if @contact_message.valid? && verify_recaptcha(model: @contact_message, secret_key: website.recaptcha_private_key)
        @contact_message.save
        SiteMailer.delay.contact_form(@contact_message)
        redirect_to support_path, notice: "Thank you for your catalog request. We'll get it out to you shortly." and return false
      end
    end
    render_template
  end

  # Fixtures requeset--added for Martin
  def fixtures_request
    @page_title = "Fixtures Request"
    @fixtures_request = FixturesRequest.new
    if request.post?
      @fixtures_request = FixturesRequest.new(fixtures_request_params)
      if @fixtures_request.valid?
        @fixtures_request.save
        redirect_to support_path, notice: t('blurbs.fixtures_request_thankyou') and return false
      end
    end
    render_template
  end

  def warranty_policy
    @page_title = "Warranty Policy"
    products = Product.all_for_website(website) - Product.non_supported(website)
    @products = products.select{|p| p if p.warranty_period.to_i > 0}
    @product_families = website.product_families.select{|pf| pf if pf.warranty_period.to_i > 0}
    render_template
  end

  # Simple list of RoHS compliant products
  def rohs
    @products = website.current_products.select{|p| p if p.rohs}
    render_template
  end

  # Service center lookup by zipcode
  def service_lookup
    @page_title = t('titles.service_centers')
    @err = ""
    @results = []
    if params[:zip]
      session[:zip] = params[:zip]
      @page_title += " " + t('near_zipcode', zip: params[:zip])
      begin
        @results = []
        count = 0
        zip = params[:zip] #(params[:zip].to_s.match(/^\d*$/)) ? "zipcode #{params[:zip]}" : params[:zip]
        origin = Geokit::Geocoders::MultiGeocoder.geocode(zip)
        brand = Brand.find(website.service_centers_from_brand_id || website.brand_id)
        brand.service_centers.near(origin: origin, within: 100).order("distance ASC").each do |d|
          unless count > 10 || d.exclude?
            @results << d
            count += 1
          end
        end

        # Add those with exact zipcode matches if none have been found by geocoding
        if count == 0 && params[:zip].to_s.match(/^\d*$/)
          brand.service_centers.where(zip: params[:zip]).each do |d|
            unless count > 10 || d.exclude?
              @results << d
              count += 1
            end
          end
        end
        unless count > 0
          @err = t('errors.no_service_centers_found', zip: params[:zip])
        end
      rescue
        redirect_to(support_path, alert: t('errors.geocoding')) and return false
      end
    end
    render_template
  end

  # Vintage repair facilities
  def vintage_repair
    @page_title = "Vintage Repair"
    @results = ServiceCenter.where(brand_id: website.brand_id, vintage: true)
  end

  # All repair facilities
  def all_repair
    @page_title = "All Repair Facilities"
    @service_centers = website.brand.service_centers
  end

  # Power Supplies page. Really, this could be used to build a similar page for
  # any Specification
  def power_supplies
    @specification = Specification.where(name: "Power Supply").first
    render_template
  end

  # Downloads page
  def downloads
    @site_elements = SiteElement.where(brand_id: website.brand_id, show_on_public_site: true, link_status: ["", nil, "200"]).ransack(params[:q])
    if params[:view_by].present?
      if params[:view_by] == "products"
        @discontinued_products = website.discontinued_and_vintage_products
        @products = website.current_and_discontinued_products - @discontinued_products
        if params[:selected_object]
          @product = Product.find(params[:id])
        end
      elsif params[:view_by] == "download_types"
        downloads = website.all_downloads(current_user)
        if params[:selected_object]
          if params[:selected_object].match(/(\%.*$)/)
            raise ActionController::UnpermittedParameters.new [$1] and return false
          end
          @download_type = downloads[params[:selected_object]]
        end
        @download_types = downloads.keys.sort.collect{|k| downloads[k]}
      end
    elsif website.brand.name.to_s.match(/architect/i) # for all legacy style download pages:
      downloads = website.all_downloads(current_user)
      @downloads = downloads.keys.sort{|a,b| a.to_s.downcase <=> b.to_s.downcase}.collect{|k| downloads[k]}
    end
    render_template
  end

  def selected_downloads_by_product
    respond_to do |format|
      format.html { redirect_to support_downloads_path(view_by: "products") }
      format.js {
        @discontinued_products = website.discontinued_and_vintage_products
        @products = website.current_and_discontinued_products - @discontinued_products
      }
    end
  end

  def selected_downloads_by_type
    respond_to do |format|
      format.html { redirect_to support_downloads_path(view_by: "download_type") }
      format.js {
        downloads = website.all_downloads(current_user)
        @download_types = downloads.keys.sort.collect{|k| downloads[k]}
      }
    end
  end

  def downloads_by_product
    respond_to do |format|
      format.html { redirect_to support_downloads_path(view_by: "products", selected_object: params[:id]) }
      format.js {
        @product = Product.find(params[:id])
      }
    end
  end

  def downloads_by_type
    respond_to do |format|
      format.html { redirect_to support_downloads_path(view_by: "download_type", selected_object: params[:id]) }
      format.js {
        downloads = website.all_downloads(current_user)
        @download_type = downloads[params[:id]].present? ? downloads[params[:id]] : {}
      }
    end
  end

  def downloads_search
    @site_elements = SiteElement.where(brand_id: website.brand_id, show_on_public_site: true).ransack(params[:q])
    @results = @site_elements.result(:distinct => true)
    render_template
  end

  # For dbx, a quick list of CAD files
  def cad
    @page_title = "CAD Files"
    render_template
  end

  # Also for dbx, a list of speaker tunings
  def speaker_tunings
    @page_title = "Speaker Tunings"
    render_template
  end

  private

  # Validate captcha data from params[:yoyo] (question_key) and params[:ans] (answer#)
  def validate_captcha
    Captcha.correct?(session[:yoyo], params[:ans])
  end

  def require_country?
    url_matches?("lexicon") || url_matches?("digitech") || url_matches?("hardwire") || url_matches?("vocalist")
  end

  def url_matches?(name)
    !!(website.brand.name.match(/#{name}/i))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def warranty_registration_params
    params.require(:warranty_registration).permit(:title, :first_name, :last_name, :middle_initial, :company, :jobtitle, :country, :email, :subscribe, :product_id, :serial_number, :registered_on, :purchased_on, :purchased_from, :purchase_country, :purchase_price, :comments)
  end

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message, :product, :operating_system, :company, :account_number, :phone, :fax, :billing_address, :billing_city, :billing_state, :billing_zip, :shipping_address, :shipping_city, :shipping_state, :shipping_zip, :product_sku, :product_serial_number, :warranty, :purchased_on, :part_number, :board_location, :shipping_country, :message_type)
  end

  def fixtures_request_params
    params.require(:fixtures_request).permit(:name, :email, :country, :phone, :lighting_controllers,
                                             :fixture_name, :manufacturer, :product_link, :required_modes,
                                             :required_on, :notes, :attachment)
  end

end  #  class SupportController < ApplicationController
