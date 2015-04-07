class ProductsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: [:show, :buy_it_now, :preview, :introducing]

  # GET /products
  # GET /products.xml
  def index
    redirect_to product_families_path, status: :moved_permanently
  end

  # Index of discontinued products
  # GET /discontinued_products
  def discontinued_index
    @products = website.discontinued_and_vintage_products.sort_by{ :name }
    @product_families = @products.map{|p| p.product_families}.flatten.uniq.select{|pf| pf if pf.brand_id == website.brand_id }.sort_by{ :name }
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
    respond_to do |format|
      format.html {
        unless @product.show_on_website?(website)
          unless can?(:manage, @product) || (session[:preview_products] && session[:preview_products].include?(@product.id))
            if !@product.password.blank?
              redirect_to preview_product_path(@product) and return
            else
              render text: "Not available" and return
            end
          end
        end
        if @product.discontinued?
          @alternatives = @product.alternatives
        end
        #  render_template(action: "discontinued") and return
        # If a particular product needs a custom page, create its html.erb template in
        # app/views/{website-brand-folder}/products/{product-friendly-id}.html.erb
        if !@product.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}.html.erb"))
          render template: "#{website.folder}/products/#{@product.layout_class}", layout: set_layout
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

  # New for September 2012, we are now going to have landing pages for
  # epedals when they're introduced. The content is basically the same
  # dan thing as a regular product page. Why do we do this? I don't know.
  # But, here's how you would link to it:
  #
  # Example:
  #    /en-US/introducing/unplugged
  #
  # Somehow I need to remove access to the landing page after some time
  # since it features the introductory 99 cent price.
  def introducing
    if @product.show_on_website?(website) || can?(:manage, @product)
      @product_introduction = ProductIntroduction.where(product_id: @product.id).first || ProductIntroduction.new
      if @product_introduction.expired?
        redirect_to @product, status: :moved_permanently
      elsif !@product_introduction.layout_class.blank? && File.exist?(Rails.root.join("app", "views", website.folder, "products", "introducing", "#{@product_introduction.layout_class}.html.erb"))
        render template: "#{website.folder}/products/introducing/#{@product_introduction.layout_class}", layout: set_layout
      elsif !@product.layout_class.blank? && File.exist?(Rails.root.join("app", "views", website.folder, "products", "introducing", "#{@product.layout_class}.html.erb"))
        render template: "#{website.folder}/products/introducing/#{@product.layout_class}", layout: set_layout
      else
        render_template
      end
    else
      render text: "No active product found" and return
    end
  end

  def buy_it_now
    respond_to do |format|
      format.html {
        if !@product.in_production?
          redirect_to where_to_buy_path and return
        elsif !@product.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}_buy_it_now.html.erb"))
          render template: "#{website.folder}/products/#{@product.layout_class}_buy_it_now", layout: set_layout
        elsif @product.layout_class.to_s == 'epedal' && website.non_ios_howto_url
          redirect_to website.non_ios_howto_url and return
        elsif !@product.direct_buy_link.blank?
          redirect_to @product.direct_buy_link and return
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
          session[:preview_products] << @product.id
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
    # params[:product_ids] ||= []
    if params[:product_ids]
      params[:product_ids].each do |p|
        product = Product.find(p)
        @products << product
        @specs += product.product_specifications.collect{|ps| ps.specification}
      end
    end
    if @products.size <= 1
      redirect_to product_families_path, alert: "Must select 2 or more products to compare. #{params[:product_ids]}"
    elsif @products.size > 4
      redirect_to product_families_path, alert: "Select no more than 4 products to compare."
    else
      @specs.uniq!
      render_template
    end
  end
  
  # GET /products/songlist/1.xml
  # where "1" is a ProductAttachment id (not a Product id)
  def songlist
    begin
      @product_attachment = ProductAttachment.where(songlist_tag: params[:id]).first
      @songs = @product_attachment.demo_songs
    rescue
      @songs = [DemoSong.new]
    end
    respond_to do |format|
      format.html { render text: "This method is designed as an XML call only. Please add '.xml' to your request."}
      format.xml
    end
  end
  
  protected
  
  def ensure_best_url
    @product = Product.where(cached_slug: params[:id]).first || Product.find(params[:id])
    unless @product.belongs_to_this_brand?(website)
      redirect_to product_families_path and return 
    end
    # redirect_to @product, status: :moved_permanently unless @product.friendly_id_status.best?
  end

end
