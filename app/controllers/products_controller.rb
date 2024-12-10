class ProductsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: [:show, :buy_it_now, :preview, :photometric, :bom, :compliance]
  before_action :verify_warranty_admin_ability, only: [:edit_warranty, :update_warranty]

  # GET /products
  # GET /products.xml
  def index
    redirect_to product_families_path, status: :moved_permanently
  end

  # Index of discontinued products
  # GET /discontinued_products
  def discontinued_index
    if request.post? && params[:product] && params[:product][:id]
      product = Product.find(params[:product][:id])
      redirect_to product and return false
    else
      @products = website.discontinued_and_vintage_products.order("UPPER(products.name)")
      product_ids = @products.unscope(:order).pluck(:id)
      product_family_ids = ProductFamilyProduct.select(:product_family_id).where(product_id: product_ids).distinct
      @product_families = ProductFamily.where(id: product_family_ids, brand_id: website.brand_id).order("name")
      render_template
    end
  end

  # GET /products/1
  # GET /products/1.xml
  #
  # Loads the product page. Buy It Now buttons are populated by default
  # with a popup for all of the online retailers carrying the product.
  #
  # To link directly to one of the online retailers, add the "bin" URL
  # parameter with the friendly_id of the online retailer:
  #
  # Example:
  #
  #    /en-US/products/istomp?bin=musicians-friend
  #
  # To link directly to a single, random selection of the buy-it-now
  # retailers, add the "rbin" URL parameter set to "true" or "1"
  #
  # Example:
  #    /en-US/products/istomp?rbin=1
  #
  def show
    unless @product.locales(website).include?(I18n.locale.to_s)
      if @product.geo_alternative(website, I18n.locale.to_s)
        redirect_to @product.geo_alternative(website, I18n.locale.to_s) and return
      else
        # Log these to determine alternatives that need to be created
        product_locale = @product.locales(website).first
        #logger.geo.debug("#{request.url}, #{request.remote_ip}, GeoCountry: #{session[:geo_country]}, I18n.locale: #{ I18n.locale.to_s }, Product Locales: #{ @product.locales(website).inspect }, Redirecting to: #{ product_locale }")
        redirect_to product_path(@product, locale: product_locale), status: :moved_permanently and return
        #raise ActionController::RoutingError.new('Not Found')
      end
    end

    if @product.brand != website.brand && website.brand.redirect_product_pages_to_parent_brand? && website.brand.default_website.present?
      redirect_to product_url(@product, host: @product.brand.default_website.url), allow_other_host: true and return false
    elsif @product.product_page_url.present?
      unless @product.product_page_url.match?(/#{request.original_url}/i)
        redirect_to @product.product_page_url, allow_other_host: true and return false
      end
    end

    if website.has_suggested_products?
      @suggestions = @product.suggested_products
    end
    @online_retailer_link = nil
    if params[:bin]
      online_retailer = OnlineRetailer.find(params[:bin])
      @online_retailer_link = online_retailer.online_retailer_links.where(product_id: @product.id).first
    elsif params[:rbin]
      @online_retailer_link = @product.randomized_retailer_links.first # already randomized
    end
    @active_tab = params[:tab] || 'description'

    @promo = @product.first_promo_with_price_adjustment

    if can?(:manage, @product)
      3.times { @product.product_videos.build }
      3.times { @product.product_case_studies.build }
    end

    respond_to do |format|
      format.html {
        @hreflangs = @product.hreflangs(website)

        unless @product.show_on_website?(website)
          unless can?(:manage, @product) || (session[:preview_products] && session[:preview_products].include?(@product.friendly_id))
            if !@product.password.blank?
              redirect_to preview_product_path(@product) and return
            else
              render plain: "Not available" and return
            end
          end
        end
        if @product.discontinued?
          @alternatives = @product.alternatives
        end
        #  render_template(action: "discontinued") and return
        # If a particular product needs a custom page, create its html.erb template in
        # app/views/{website-brand-folder}/products/{product-friendly-id}.html.erb
        if !@product.layout_class.blank?
          if File.exist?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}.html.erb"))
            render template: "#{website.folder}/products/#{@product.layout_class}", layout: set_layout
          elsif File.exist?(Rails.root.join("app", "views", "products", "#{@product.layout_class}.html.erb"))
            render template: "products/#{@product.layout_class}", layout: set_layout
          else
            render_template
          end
        else
          render_template
        end
      }
      # format.xml  {
      #   if @product.show_on_website?(website)
      #     render xml: @product
      #   else
      #     head :ok
      #   end
      # }
    end
  end

  def buy_it_now
    respond_to do |format|
      format.html {
        if !@product.in_production?
          redirect_to where_to_find_path and return
        elsif !@product.layout_class.blank? && File.exist?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}_buy_it_now.html.erb"))
          render template: "#{website.folder}/products/#{@product.layout_class}_buy_it_now", layout: set_layout
        elsif !@product.direct_buy_link.blank?
          redirect_to @product.direct_buy_link, allow_other_host: true and return
        else
          render_template
        end
      }
      format.xml { render xml: @product.randomized_retailer_links }
    end
  end

  # GET /products/1/preview
  # PUT /products/1/preview
  def preview
    @errors = ""
    if request.put?
      if @product.password == params[:product][:password]
        if params[:email] && !params[:email].blank?
          @product.previewers ||= []
          @product.previewers << params[:email]
          @product.save
          session[:preview_products] ||= []
          session[:preview_products] << @product.friendly_id
          redirect_to @product and return false
        end
      end
      @errors = "Could not continue. Please check the password."
    end
    @product.password = ""
    respond_to do |format|
      @terms_and_conditions = website.value_for('preview_terms_and_conditions') || "Do not share information on the following page."
      format.html { render_template(layout: "minimal") }
    end
  end

  def compare
    @products = []
    @specs = []
    @spec_groups = []
    # params[:product_ids] ||= []
    if params[:product_ids]
      params[:product_ids].each do |p|
        product = Product.find(p)
        @products << product
      end
    end
    if @products.size <= 1
      redirect_to product_families_path, alert: "Must select 2 or more products to compare. #{params[:product_ids]}"
    elsif @products.size > 6
      redirect_to product_families_path, alert: "Select no more than 6 products to compare."
    else
      spec_ids = @products.collect{|p| p.product_specifications.collect{|ps| ps.specification_id}}.flatten.uniq
      product_specs = Specification.where(id: spec_ids)
      if website.brand.specification_for_comparisons.length > 0
        brand_specs = website.brand.specification_for_comparisons.where(specification_id: spec_ids).order("position")
        @specs = (brand_specs.length > 0) ? brand_specs.map{|s| s.specification} : product_specs
      else
        @specs = product_specs
      end
      if !website.brand.use_flattened_specs? && @specs.where("specification_group_id IS NOT NULL").count > 0
        spec_group_ids = @specs.where("specification_group_id IS NOT NULL").pluck(:specification_group_id).uniq.compact
        @spec_groups = SpecificationGroup.where(id: spec_group_ids).order("position")
      end
      render_template
    end
  end

  # GET /product/ID/photometric
  # New for the martin.com site migration, setting up an iframe page for products whose
  # photometric_id is not blank. The iframe will load data from photometrics.martin.com
  def photometric
    if @product.photometric_id.blank?
      redirect_to @product and return false
    end
  end

  # GET /product/ID/bom
  # New for martin.com, display the bill of materials for a product. Only available
  # to roles with access to view parts
  def bom
    if can?(:read, Part)
      @search = @product.parts.ransack(params[:q])
      @searched = false
      @search_results = []
      if params[:q]
        @search_results = @search.result(:distinct => true)
        @searched = true
      end
      render_template
    else
      redirect_to @product, alert: "Bill of material access denied." and return false
    end
  end

  def edit_warranty
    @products = Product.all_for_website(website) - Product.non_supported(website)
    @product_families = website.product_families
  end

  def update_warranty
    [Product, ProductFamily].each do |klass|
      update_warranty_of(klass)
    end

    website.settings.where(name: "extra_warranty_side_content").first_or_initialize.update(
      text_value: params[:extra_warranty_side_content],
      setting_type: "text",
      brand_id: website.brand_id
    )

    redirect_to(warranty_policy_path, notice: "Warranty periods updated successfully.")
  end

  def compliance
    respond_to do |f|
      f.html { redirect_to @product }
      f.js
    end
  end

  protected

  def verify_warranty_admin_ability
    authorize! :manage_warranty_of, Product
  end

  def ensure_best_url
    begin
      @product = Product.where(cached_slug: params[:id]).first || Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to search_path(query: params[:id].to_s.gsub(/\_|\-/, " ")) and return false
    end
    unless @product.belongs_to_this_brand?(website)
      redirect_to product_families_path and return
    end
    # redirect_to @product, status: :moved_permanently unless @product.friendly_id_status.best?
  end

  private


  def update_warranty_of(klass)
    ids_with_nil = []

    Array(params["#{klass.name.underscore}_attr".to_sym].to_unsafe_h).each do |key, attr|
      if attr.blank?
        ids_with_nil << key
      else
        update_item_warranty(klass, key, attr)
      end
    end

    if ids_with_nil.length > 0
      klass.where(id: ids_with_nil).update_all(warranty_period: nil)
    end
  end

  def update_item_warranty(klass, key, attr)
    item = klass.where(id: key).select(:id, :warranty_period).first
    if item.warranty_period != attr
      item.update_columns(warranty_period: attr)
    end
  end

end
