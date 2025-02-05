class Admin::ProductsController < AdminController
  before_action :initialize_product, only: :create
  load_and_authorize_resource
  skip_authorize_resource only: [:rohs, :update_rohs, :harman_employee_pricing, :update_harman_employee_pricing]

  # GET /admin/products
  # GET /admin/products.xml
  def index
    @products = website.products
    if params[:q].present?
      @search = @products.ransack(params[:q])
      @products = @search.result
    else
      @search = @products.ransack
    end
    respond_to do |format|
      format.html {
        if params[:q] && @products.size == 1
          redirect_to [:admin, @products.first]
        else
          render_template
        end
      } # index.html.erb
      format.xml  { render xml: @products }

      # This is not a complete export of product data. There was a specific request to audit
      # the downloads for the products via spreadsheet. So here it is...
      format.csv {
        send_data(
          CSV.generate(headers: true) do |csv|
            csv << ["model", "short description", "status", "downloads"]

            @products.each do |p|
              csv << [p.name, p.short_description, p.product_status.name, p.product_documents.map{|d| d.document_file_name}.join(", ")]
            end
          end,
          filename: "#{website.brand.name.parameterize}_products_downloads_#{I18n.l Date.today}.csv",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end
  end

  # GET /admin/products/1
  # GET /admin/products/1.xml
  def show
    @product_family_product = ProductFamilyProduct.new(product: @product)
    @online_retailer_link   = OnlineRetailerLink.new(product: @product)
    @product_attachment     = ProductAttachment.new(product: @product)
    @product_document       = ProductDocument.new(product: @product)
    @product_software       = ProductSoftware.new(product: @product)
    @product_specification  = ProductSpecification.new(product: @product)
    @artist_product         = ArtistProduct.new(product: @product)
    @product_effect         = ProductEffect.new(product: @product)
    @product_training_module = ProductTrainingModule.new(product: @product)
    @product_training_class = ProductTrainingClass.new(product: @product)
    @product_suggestion     = ProductSuggestion.new(product: @product)
    @parent_product         = ParentProduct.new(product_id: @product.id)
    @product_video          = ProductVideo.new(product_id: @product.id)
    @product_badge          = ProductBadge.new(product_id: @product.id)
    @product_accessory      = ProductAccessory.new(product_id: @product.id)
    @accessory_product      = ProductAccessory.new(accessory_product_id: @product.id)
    3.times { @product.product_case_studies.build }
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product }
    end
  end

  # GET /admin/products/new
  # GET /admin/products/new.xml
  def new
    @product.brand = website.brand
    @product.layout_class = website.brand.default_layout_class_for_products
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product }
    end
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products
  # POST /admin/products.xml
  def create
    @product.brand = website.brand
    @product.layout_class ||= @product.brand.default_layout_class_for_products
    respond_to do |format|
      if @product.save
        format.html { redirect_to([:admin, @product], notice: 'Product was successfully created.') }
        format.xml  { render xml: @product, status: :created, location: @product }
        website.add_log(user: current_user, action: "Created product: #{@product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    new_product = @product.copy!
    redirect_to(
      [:admin, new_product],
      notice: "The new product (below) is hidden from the public site. Update the product status when you're ready to launch it."
    )
  end

  # PUT /admin/products/1
  # PUT /admin/products/1.xml
  def update
    respond_to do |format|
      if @product.update(product_params)
        @product.touch # clear cache
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Product was successfully updated.")
          else
            redirect_to([:admin, @product], notice: 'Product was successfully updated.')
          end
        }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product: #{@product.name}")
      else
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, alert: "There was a problem with the changes.")
          else
            render action: "edit"
          end
        }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1
  # DELETE /admin/products/1.xml
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_products_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted product: #{@product.name}")
  end

  # Custom method to list all products and their RoHS status
  # GET /admin/products/rohs
  def rohs
    authorize! :update, :rohs
    @products = website.products
    respond_to do |format|
      format.html { render_template } # only have html output for now
    end
  end

  # Custom method to update RoHS status for all products at once
  # PUT /admin/products/update_rohs
  def update_rohs
    authorize! :update, :rohs
    rohs_ids = params[:products]
    website.products.each do |product|
      if rohs_ids.include?(product.id.to_s)
        product.update(rohs: true) unless product.rohs?
      else
        product.update(rohs: false) if product.rohs?
      end
    end
    respond_to do |format|
      format.html { redirect_to(rohs_admin_products_path, notice: 'RoHS list updated successfully.') }
    end
    website.add_log(user: current_user, action: "Updated ROHS list")
  end

  # Update pricing for "myharman.com" employee accommodation site
  def harman_employee_pricing
    authorize! :update, :harman_employee_pricing
    @products = website.products
    render_template
  end

  def artist_pricing
    authorize! :view, :artist_pricing
    @products = website.products
    render_template
  end

  # Update action for the myharman.com pricing form
  def update_harman_employee_pricing
    authorize! :update, :harman_employee_pricing
    Array(params[:product_attr].to_unsafe_h).each do |key, attr|
      product = Product.find(key)
      product.update(attr)
    end
    redirect_to(harman_employee_pricing_admin_products_path, notice: "Pricing updated successfully.")
  end

  # Delete custom background
  def delete_background
    @product = Product.find(params[:id])
    @product.update(background_image: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_path(@product), notice: "Background was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted #{@product.name} custom background")
  end

  # Hacking together a page to update which products belong to enterprise or entertainment
  def solutions
    @products = website.products
  end

  def update_solutions
    website.products.update_all(enterprise: false, entertainment: false, updated_at: Time.now)
    website.products.where(id: params[:enterprise]).update_all(enterprise: true, updated_at: Time.now)
    website.products.where(id: params[:entertainment]).update_all(entertainment: true, updated_at: Time.now)
    redirect_to(admin_solutions_path, notice: "Product groups were updated successfully.")
  end

  private

  def initialize_product
    @product = Product.new(product_params)
  end

  def product_params
    params.require(:product).permit(
      :name,
      :sap_sku,
      :short_description,
      :keywords,
      :product_status_id,
      :rohs,
      :background_image,
      :background_color,
      :password,
      :previewers,
      :has_pedals,
      :brand_id,
      :warranty_period,
      :layout_class,
      :direct_buy_link,
      :features_tab_name,
      :demo_link,
      :hide_buy_it_now_button,
      :more_info_url,
      :short_description_1,
      :short_description_2,
      :short_description_3,
      :short_description_4,
      :available_on,
      :harman_employee_price,
      :street_price,
      :msrp,
      :sale_price,
      :cost,
      :alert,
      :show_alert,
      :extended_description_tab_name,
      :product_page_url,
      :legal_disclaimer,
      :show_recommended_verticals,
      :enterprise,
      :entertainment,
      :registration_notice,
      :photometric_id,
      :hidden_content,
      :old_url,
      :hidden_locales,
      :meta_description,
      :hide_contact_buttons,
      :firmware_name,
      :description,
      :extended_description,
      :features,
      :collapse_content,
      :geo_parent_id,
      :highlight_format,
      :hide_product_photo,
      :custom_css,
      :training_url,
      product_prices_attributes: {},
      product_specifications_attributes: {},
      product_product_filter_values_attributes: {},
      customizable_attribute_values_attributes: {},
      suggested_product_id: [],
      product_videos_attributes: {},
      product_case_studies_attributes: {}
    )
  end
end
