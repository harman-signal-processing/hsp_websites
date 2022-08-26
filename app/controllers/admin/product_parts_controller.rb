class Admin::ProductPartsController < AdminController
  before_action :initialize_product_part, only: :create
  load_and_authorize_resource
  # GET /product_parts
  # GET /product_parts.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_parts }
    end
  end

  # GET /product_parts/1
  # GET /product_parts/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_part }
    end
  end

  # GET /product_parts/new
  # GET /product_parts/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_part }
    end
  end

  # GET /product_parts/1/edit
  def edit
  end

  # POST /product_parts
  # POST /product_parts.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_parts.present?
        begin
          @product_parts.each do |product_part|
            begin
              product_part.save!
              website.add_log(user: current_user, action: "Added #{product_part.part.part_number} to #{product_part.product.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_parts/create_error" }
            end
          end
        rescue
          # format.js { render template: "admin/product_parts/create_error" }
        end
      elsif @product_part.present?
        if @product_part.save
          format.html { redirect_to([:admin, @product_part.product], notice: 'Product/part was successfully created.') }
          format.xml  { render xml: @product_part, status: :created, location: @product_part }
          format.js
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_part.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /product_parts/1
  # PUT /product_parts/1.xml
  def update
    respond_to do |format|
      if @product_part.update(product_part_params)
        format.html { redirect_to([:admin, @product_part.product], notice: 'Product/part was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_parts/1
  # DELETE /product_parts/1.xml
  def destroy
    @called_from = params[:called_from] || 'product'
    @product_part.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_part.product]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_part
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_part_params[:product_id].is_a?(Array)
      @product_parts = []
      part_id = product_part_params[:part_id]
      product_part_params[:product_id].reject(&:blank?).each do |product|
        @product_parts << ProductPart.new({part_id: part_id, product_id: product})
      end
    elsif product_part_params[:part_id].is_a?(Array)
      @product_parts = []
      product_id = product_part_params[:product_id]
      product_part_params[:part_id].reject(&:blank?).each do |part|
        @product_parts << ProductPart.new({part_id: part, product_id: product_id})
      end
    else
      @product_part = ProductPart.new(product_part_params)
    end
  end

  def product_part_params
    params.require(:product_part).permit(:part_id, :product_id, product_id: [], part_id: [])
  end
end
