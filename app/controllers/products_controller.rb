class ProductsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: [:show, :buy_it_now, :preview]
  
  # GET /products
  # GET /products.xml
  def index
    redirect_to product_families_path
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    if website.has_suggested_products?
      @suggestions = @product.suggested_products
    end
    @online_retailer_link = nil
    if params[:bin]
      online_retailer = OnlineRetailer.find(params[:bin])
      @online_retailer_link = online_retailer.online_retailer_links.where(product_id: @product.id).first
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
          render_template(action: "discontinued") and return
        # If a particular product needs a custom page, create its html.erb template in
        # app/views/{website-brand-folder}/products/{product-friendly-id}.html.erb
        elsif !@product.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}.html.erb"))
          render template: "#{website.folder}/products/#{@product.layout_class}", layout: set_layout
        else
          render_template
        end
      }
      format.xml  { 
        if @product.show_on_website?(website)
          render xml: @product 
        else
          head :ok
        end
      }
    end
  end

  def buy_it_now
    respond_to do |format|
      format.html {
        if !@product.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "products", "#{@product.layout_class}_buy_it_now.html.erb"))
          render template: "#{website.folder}/products/#{@product.layout_class}_buy_it_now", layout: set_layout
        else
          render_template
        end
      }
      format.xml { render xml: @product.active_retailer_links }
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
  
  # GET /products/songlist/1.xml
  # where "1" is a ProductAttachment id (not a Product id)
  def songlist
    begin
      @product_attachment = ProductAttachment.find_by_songlist_tag(params[:id])
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
    @product = Product.find_by_cached_slug(params[:id]) || Product.find(params[:id])
    unless @product.belongs_to_this_brand?(website)
      redirect_to product_families_path and return 
    end
    # redirect_to @product, status: :moved_permanently unless @product.friendly_id_status.best?
  end

end
