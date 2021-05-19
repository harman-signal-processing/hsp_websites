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
  end

  def partner_search
    @page_title = website.brand.name.to_s.match(/duran audio/i) ? t('titles.enquire') : t('titles.where_to_buy')
    @err = ""
    @js_map_loader = ''
    @results = []
    do_search
    respond_to do |format|
      format.html {
        unless @results.size > 0
          @err = t('errors.no_dealers_found', zip: params[:zip])
        else
          @js_map_loader = "map_init('#{@results.first.lat}','#{@results.first.lng}',7)"
        end
        render_template
      }

      format.json {
        respond_with @results.to_json(except: [:account_number, :brand_id, :created_at, :updated_at, :name2, :name3, :name4])
      }
    end
  end

  def vertec_vtx_owners
    respond_to do |format|
      format.xls {
        report_data = Dealer.report(
          website.brand, {
            rental: true,
            title: 'VERTEC/VTX OWNERS DIRECTORY',
            format: 'xls'
          }
        )
        send_data(report_data,
          filename: "#{website.brand.name}_vertec-vtx-owners_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end
  end

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
    rescue
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
      unless results.length >= 1000 || d.exclude? || filter_out?(d)
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
      unless results.length >= max || d.exclude? || filter_out?(d)
        d.distance = d.distance_from(origin)
        results << d unless results.include?(d)
      end
    end

    if !!origin.try(:state)
      # adding dealers in state to the list
      brand.dealers.where(state: origin.state).find_each do |d|
        unless d.exclude? || filter_out?(d)
          d.distance = d.distance_from(origin)
          results << d unless results.include?(d)
        end
      end
    end

    # Add those with exact zipcode matches if none have been found by geocoding
    if results.length < max && opts[:zip].to_s.match(/^\d*$/)
      brand.dealers.where("zip LIKE ?", opts[:zip]).find_each do |d|
        unless results.length >= 1000 || d.exclude? || filter_out?(d)
          d.distance = d.distance_from(origin)
          results << d unless results.include?(d)
        end
      end
    end

    # sort results by distance
    results.sort_by{|d| d.distance_from(origin) }
  end

  # Returning true would remove the dealer from results
  def filter_out?(dealer)
    if params[:apply_filters].present? && !!(params[:apply_filters].to_i == 1)
      @filter_resale = !!params[:resale]
      @filter_rental = !!params[:rental]
      @filter_service = !!params[:service]

      return false if @filter_resale && dealer.resale?
      return false if @filter_rental && dealer.rental?
      return false if @filter_service && dealer.service?

      true
    end
  end

end
