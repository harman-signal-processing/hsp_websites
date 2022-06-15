class WhereToFindController < ApplicationController
  respond_to :html, :json

  def index
    unless I18n.locale.to_s.match(/en/i)
      redirect_to international_distributors_path and return
    end
    @page_title = website.brand.name.to_s.match(/duran audio/i) ? t('titles.enquire') : t('titles.where_to_buy')
    @us_regions = website.brand.us_regions_for_website
    @us_region = UsRegion.new
    @countries = Distributor.countries(website)
    @country = nil
    @lead = Lead.new
    render_template
  end  #  def index

  def partner_search
    @page_title = website.brand.name.to_s.match(/duran audio/i) ? t('titles.enquire') : t('titles.where_to_buy')
    @err = ""
    @js_map_loader = ''
    @results = []
    do_search

    # download_search_results(@results)

    respond_to do |format|
      format.html {
        unless @results.size > 0
          @err = "#{t('errors.no_dealers_found', zip: params[:zip])} with selected criteria."
          @js_map_loader = "map_init('#{@origin.lat}','#{@origin.lng}',6.5)" if @origin.present?
        else
          @js_map_loader = "map_init('#{@results.first.lat}','#{@results.first.lng}',6.5)"
        end
        render_template
      }

      format.json {
        respond_with @results.to_json(except: [:account_number, :brand_id, :created_at, :updated_at, :name2, :name3, :name4])
      }
    end
  end  #  def partner_search

  def vertec_vtx_owners_search
    @page_title = "Find VTX / VT Rental Companies"
    @err = ""
    @js_map_loader = ''
    @results = []
    do_search

    # ensure is rental and has products
    @results = @results.select{|d| d.rental? && Dealer.rental_products_tour_only(website.brand, d).present? }

    respond_to do |format|
      format.html {
        if @results.size > 0
          @js_map_loader = "map_init('#{@results.first.lat}','#{@results.first.lng}',6.5)"
        elsif @results.size == 0 && params[:zip].present?
          @err = t('errors.no_dealers_found', zip: params[:zip])
          @js_map_loader = "map_init('#{@origin.lat}','#{@origin.lng}',6.5)" if @origin.present?
        end
          render_template
      }

      format.json {
        respond_with @results.to_json(except: [:account_number, :brand_id, :created_at, :updated_at, :name2, :name3, :name4])
      }
    end
  end  #  def vertec_vtx_owners_search

  def vtx_owners_list
    Rails.cache.fetch("jbl_vtx_owners", expires_in: 6.hours) do
      vtx_dealers = website.brand.dealers
      vtx_dealers.reject{|item| !item.has_rental_products_for(website.brand, "vt") }.sort_by{|item| [item.region, item.country, item.name] }
    end
  end

  def vertec_vtx_owners
    vtx_dealers = vtx_owners_list
    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report(
          website.brand, {
            # rental: true,
            # title: 'VTX OWNERS DIRECTORY',
            format: 'xls'
          }, vtx_dealers
        )
        send_data(report_data,
          filename: "#{website.brand.name}_vtx-dealers_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|
  end  #  def vertec_vtx_owners

  def prx_one_dealers_list
    Rails.cache.fetch("jbl_prx_one_dealers", expires_in: 6.hours) do
      prx_one_dealers = website.brand.dealers
      prx_one_dealers.reject{|item| !item.has_rental_products_for(website.brand, "prx-one") }.sort_by{|item| [item.region, item.country, item.name] }
    end  # Rails.cache.fetch("jbl_prx_one_dealers", expires_in: 6.hours) do
  end  #  def prx_one_dealers_list

  def prx_one_dealers
    prx_one_dealers = prx_one_dealers_list
    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report(
          website.brand, {
            format: 'xls'
          }, prx_one_dealers
        )
        send_data(report_data,
          filename: "#{website.brand.name}_prx-one-dealers_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|
  end  #  def prx_one_dealers

  def eon_one_mk2_dealers_list
    Rails.cache.fetch("jbl_eon_one_mk2_dealers", expires_in: 6.hours) do
      eon_one_mk2_dealers = website.brand.dealers
      eon_one_mk2_dealers.reject{|item| !item.has_rental_products_for(website.brand, "jbl-eon-one-mk2") }.sort_by{|item| [item.region, item.country, item.name] }
    end
  end

  def eon_one_mk2_dealers
    eon_one_mk2_dealers = eon_one_mk2_dealers_list
    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report(
          website.brand, {
            format: 'xls'
          }, eon_one_mk2_dealers
        )
        send_data(report_data,
          filename: "#{website.brand.name}_eon-one-mk2-dealers_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|
  end  #  def eon_one_mk2_dealers

  def eon700_series_dealers_list
    Rails.cache.fetch("jbl_eon700_series_dealers", expires_in: 6.hours) do
      eon700_series_dealers = website.brand.dealers
      eon700_series_dealers.reject{|item| !item.has_rental_products_for(website.brand, "jbl-eon7") }.sort_by{|item| [item.region, item.country, item.name] }
    end  # Rails.cache.fetch("jbl_eon700_series_dealers", expires_in: 6.hours) do
  end

  def eon700_series_dealers
    eon700_series_dealers = eon700_series_dealers_list
    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report(
          website.brand, {
            format: 'xls'
          }, eon700_series_dealers
        )
        send_data(report_data,
          filename: "#{website.brand.name}_eon700-series-dealers_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|
  end  #  def eon700_series_dealers

  def download_partner_search_results
    @err = ""
    @js_map_loader = ''
    @results = []
    do_search

    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report(
          website.brand, {
            rental: true,
            title: 'JBL Professional Search Results',
            format: 'xls'
          }, @results
        )
        send_data(report_data,
          filename: "#{website.brand.name}_partner_search_results_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|
  end  #  def download_partner_search_results

  private

  def do_search
    return false, session[:zip] = '' if search_params_missing?

    session[:zip] = params[:zip] if params[:zip].present?
    brand = Brand.find(website.dealers_from_brand_id || website.brand_id)
    @origin = get_origin

    begin
      if Rails.env.production? || Rails.env.development?
        @results = get_results(brand, @origin, params)
      else # skipping geocoding for test
        @results = get_brand_dealer_results_for_test(brand)
      end
    rescue => e
      redirect_to(where_to_find_path, alert: t('errors.geocoding')) and return false
    end

  end

  def search_params_missing?
    !params[:zip].present? && !params[:lat].present? && !params[:lng].present?
  end

  def get_origin
    if params[:lat] && params[:lng]
      origin = [params[:lat], params[:lng]].map(&:to_f)
    elsif params[:zip].present?
      origin = Geokit::Geocoders::MultiGeocoder.geocode(params[:zip])
    end
    origin
  end

  def get_brand_dealer_results_for_test(brand)
    results = []
    brand.dealers.each do |d|
      unless results.length >= 1000 || d.exclude? || filter_out?(brand,d)
        results << d unless results.include?(d)
      end
    end  #  brand.dealers.each do |d|
    results
  end  #  def get_brand_dealer_results_for_test(brand)

  def get_results(brand, origin, opts={})
    results = []
    max = 999
    within_miles = 150

    brand.dealers.select{|d| d.distance_from(origin) <= within_miles}.each do |d|
      unless results.length >= max || d.exclude? || filter_out?(brand,d)
        d.distance = d.distance_from(origin)
        dealer_rental_products = Dealer.rental_products_and_product_families(brand, d)
        d.products = dealer_rental_products.pluck(:name, :cached_slug).to_a if dealer_rental_products.present?
        results << d unless results.include?(d)
      end  #  unless results.length >= max || d.exclude? || filter_out?(brand,d)
    end  #  brand.dealers.select{|d| d.distance_from(origin) <= within_miles}.each do |d|

    if !!origin.try(:state)
      # adding dealers in state to the list
      brand.dealers.where(state: origin.state).find_each do |d|
        unless d.exclude? || filter_out?(brand,d)
          d.distance = d.distance_from(origin)
          results << d unless results.include?(d)
        end  #  unless d.exclude? || filter_out?(brand,d)
      end  #  brand.dealers.where(state: origin.state).find_each do |d|
    end  #  if !!origin.try(:state)

    # Add those with exact zipcode matches if none have been found by geocoding
    if results.length < max && opts[:zip].to_s.match(/^\d*$/)
      brand.dealers.where("zip LIKE ?", opts[:zip]).find_each do |d|
        unless results.length >= 1000 || d.exclude? || filter_out?(brand,d)
          d.distance = d.distance_from(origin)
          results << d unless results.include?(d)
        end  #  unless results.length >= 1000 || d.exclude? || filter_out?(brand,d)
      end  #  brand.dealers.where("zip LIKE ?", opts[:zip]).find_each do |d|
    end  #  if results.length < max && opts[:zip].to_s.match(/^\d*$/)

    results.sort_by{|d| d.distance_from(origin) }
  end  #  def get_results(brand, origin, opts={})

  # Returning true would remove the dealer from results
  def filter_out?(brand,dealer)
    # This is currently only used for JBL Pro
    if params[:apply_filters].present? && !!(params[:apply_filters].to_i == 1)
      @filter_resale = !!params[:resale]
      @filter_rental_vtx = !!params[:rental_vtx]
      @filter_rental_prx_one = !!params[:rental_prx_one]
      @filter_rental_eon_one_mk2 = !!params[:rental_eon_one_mk2]
      @filter_rental_eon700_series = !!params[:rental_eon700_series]
      @filter_service = !!params[:service]


      return false if @filter_resale && dealer.resale?
      return false if @filter_rental_vtx && dealer.rental? && dealer.has_rental_products_for(brand,'vt')
      return false if @filter_rental_prx_one && dealer.rental? && dealer.has_rental_products_for(brand,'prx-one')
      return false if @filter_rental_eon_one_mk2 && dealer.rental? && dealer.has_rental_products_for(brand,'jbl-eon-one-mk2')
      return false if @filter_rental_eon700_series && dealer.rental? && dealer.has_rental_products_for(brand,'jbl-eon7')
      return false if @filter_service && dealer.service?

      true
    end  #  if params[:apply_filters].present? && !!(params[:apply_filters].to_i == 1)
  end  #  def filter_out?(dealer)

end  #  class WhereToFindController < ApplicationController
