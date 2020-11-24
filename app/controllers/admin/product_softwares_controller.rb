class Admin::ProductSoftwaresController < AdminController
  before_action :initialize_product_software, only: :create
  load_and_authorize_resource

  # GET /admin/product_softwares
  # GET /admin/product_softwares.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_softwares }
    end
  end

  # GET /admin/product_softwares/1
  # GET /admin/product_softwares/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_software }
    end
  end

  # GET /admin/product_softwares/new
  # GET /admin/product_softwares/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_software }
    end
  end

  # GET /admin/product_softwares/1/edit
  def edit
  end

  # POST /admin/product_softwares
  # POST /admin/product_softwares.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_softwares.present?
        begin
          @product_softwares.each do |product_software|
            begin
              product_software.save!
              website.add_log(user: current_user, action: "Added #{product_software.software.name} to #{product_software.product.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_site_elements/create_error" }
            end
          end
        rescue
          # format.js { render template: "admin/product_site_elements/create_error" }
        end
      elsif @product_software.present?

        if @product_software.save
          format.html { redirect_to([:admin, @product_software], notice: 'Product Software was successfully created.') }
          format.xml  { render xml: @product_software, status: :created, location: @product_software }
          format.js
          website.add_log(user: current_user, action: "Added #{@product_software.software.name} to #{@product_software.product.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_software.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end
  end

  # PUT /admin/product_softwares/1
  # PUT /admin/product_softwares/1.xml
  def update
    respond_to do |format|
      if @product_software.update(product_software_params)
        format.html { redirect_to([:admin, @product_software], notice: 'Product Software was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_software.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_softwares/update_order
  def update_order
    params["product_software"].to_a.each_with_index do |item, pos|
      if params[:called_from] == "software"
        ProductSoftware.update(item, product_position: (pos + 1))
      else
        ProductSoftware.update(item, software_position: (pos + 1))
      end
    end
    head :ok
    website.add_log(user: current_user, action: "Sorted product software")
  end

  # DELETE /admin/product_softwares/1
  # DELETE /admin/product_softwares/1.xml
  def destroy
    @called_from = params[:called_from] || 'product'
    @product_software.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_softwares_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed #{@product_software.software.name} from #{@product_software.product.name}")
  end

  private

  def initialize_product_software
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_software_params[:product_id].is_a?(Array)
      @product_softwares = []
      software_id = product_software_params[:software_id]
      product_software_params[:product_id].reject(&:blank?).each do |product|
        @product_softwares << ProductSoftware.new({software_id: software_id, product_id: product})
      end
    elsif product_software_params[:software_id].is_a?(Array)
      @product_softwares = []
      product_id = product_software_params[:product_id]
      product_software_params[:software_id].reject(&:blank?).each do |software|
        @product_softwares << ProductSoftware.new({software_id: software, product_id: product_id})
      end
    else
      @product_software = ProductSoftware.new(product_software_params)
    end
  end

  def product_software_params
    params.require(:product_software).permit(:software_id, :product_id, :product_position, :software_position)
  end
end
