class ProductFamiliesController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: :show
  
  # GET /product_families
  # GET /product_families.xml
  def index
    @product_families = website.product_families

    respond_to do |format|
      format.html { render_template } # index.html.erb
      # format.xml  { render xml: @product_families }
    end
  end

  # GET /product_families/1
  # GET /product_families/1.xml
  def show
    if !website.product_families.include?(@product_family)
      redirect_to product_families_path and return
    end
    respond_to do |format|
      format.html {
        if @product_family.current_products.size == 1
          redirect_to @product_family.current_products.first and return 
        elsif @product_family.children_with_current_products(website).size == 1 && @product_family.children_with_current_products(website).first.current_products.size == 1
          redirect_to @product_family.children_with_current_products(website).first.current_products.first and return 
        elsif !@product_family.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "product_families", "#{@product_family.layout_class}.html.erb"))
          render template: "#{website.folder}/product_families/#{@product_family.layout_class}", layout: set_layout
        else
          render_template
        end        
      }
      # format.xml  { render xml: @product_family }
    end
  end
  
  protected
  
  def ensure_best_url
    @product_family = ProductFamily.find_by_cached_slug(params[:id]) || ProductFamily.find(params[:id])
    # redirect_to @product_family, status: :moved_permanently unless @product_family.friendly_id_status.best?
  end
end
