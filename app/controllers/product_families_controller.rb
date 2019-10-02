class ProductFamiliesController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: [:show, :safety_documents]
  before_action :authorize_product_family, only: :show

  # GET /product_families
  # GET /product_families.xml
  def index
    @product_families = website.product_families
    @discontinued_products = website.discontinued_and_vintage_products
    respond_to do |format|
      format.html { render_template } # index.html.erb
      # format.xml  { render xml: @product_families }
    end
  end

  # GET /product_families/1
  # GET /product_families/1.xml
  def show
    unless @product_family.brand == website.brand || website.product_families.include?(@product_family)
      redirect_to product_families_path, status: :moved_permanently and return
    end
    @children_with_current_products = @product_family.children_with_current_products(website)
    respond_to do |format|
      format.html {

        # If the family has no fancy features and only one product
        if @product_family.features.length == 0 && @product_family.current_products.size == 1
          redirect_to @product_family.current_products.first, status: :moved_permanently and return

        # If the family has no fancy features and only one child with one active product
        elsif @product_family.features.length == 0 &&
          @children_with_current_products.size == 1 &&
          @children_with_current_products.first.current_products.size == 1
            redirect_to @children_with_current_products.first.current_products.first, status: :moved_permanently and return

        # If the family has a "layout_class" defined and we can find a template with that name
        elsif !@product_family.layout_class.blank? &&
          File.exists?(Rails.root.join("app", "views", website.folder, "product_families", "#{@product_family.layout_class}.html.erb"))
            render template: "#{website.folder}/product_families/#{@product_family.layout_class}", layout: set_layout

        # Otherwise, use the default render method
        else
          render_template
        end
      }
      # format.xml  { render xml: @product_family }
    end
  end

  def safety_documents
    render_template
  end

  protected

  def ensure_best_url
    @product_family = ProductFamily.where(cached_slug: params[:id]).first || ProductFamily.find(params[:id])
    # redirect_to @product_family, status: :moved_permanently unless @product_family.friendly_id_status.best?
  end

  def authorize_product_family
    if @product_family.requires_login?
      authenticate_or_request_with_http_basic("#{@product_family.name} - Protected") do |user, password|
        user == @product_family.preview_username && password == @product_family.preview_password
      end
    end
  end

end
