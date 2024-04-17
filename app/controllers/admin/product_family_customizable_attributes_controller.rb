class Admin::ProductFamilyCustomizableAttributesController < AdminController
  before_action :initialize_product_family_customizable_attribute, only: :create
  load_and_authorize_resource
  # GET /product_family_customizable_attributes
  # GET /product_family_customizable_attributes.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_customizable_attributes }
    end
  end

  # GET /product_family_customizable_attributes/1
  # GET /product_family_customizable_attributes/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_customizable_attribute }
    end
  end

  # GET /product_family_customizable_attributes/new
  # GET /product_family_customizable_attributes/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_customizable_attribute }
    end
  end

  # GET /product_family_customizable_attributes/1/edit
  def edit
  end

  # POST /product_family_customizable_attributes
  # POST /product_family_customizable_attributes.xml
  def create
    @called_from = params[:called_from] || 'product_family'

    if @product_family_customizable_attributes.present?
      @product_family_customizable_attributes.each do |product_family_customizable_attribute|
        begin
          product_family_customizable_attribute.save!
          format.js
        rescue
          # format.js { render template: "admin/product_family_customizable_attributes/create_error" }
        end
      end
    else
      respond_to do |format|
        if @product_family_customizable_attribute.save
          format.html { redirect_to([:admin, @product_family_customizable_attribute.customizable_attribute], notice: 'Product Family Customizable Attribute was successfully created.') }
          format.xml  { render xml: @product_family_customizable_attribute, status: :created, location: @product_family_customizable_attribute }
          format.js
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_family_customizable_attribute.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /product_family_customizable_attributes/1
  # PUT /product_family_customizable_attributes/1.xml
  def update
    respond_to do |format|
      if @product_family_customizable_attribute.update(product_family_customizable_attribute_params)
        format.html { redirect_to([:admin, @product_family_customizable_attribute.customizable_attribute], notice: 'Product Family Customizable Attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_customizable_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_family_customizable_attributes/1
  # DELETE /product_family_customizable_attributes/1.xml
  def destroy
    @product_family_customizable_attribute.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_family_customizable_attribute.customizable_attribute]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_family_customizable_attribute
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_family_customizable_attribute_params[:customizable_attribute_id].is_a?(Array)
      @product_family_customizable_attributes = []
      product_family_id = product_family_customizable_attribute_params[:product_family_id]
      product_family_customizable_attribute_params[:customizable_attribute_id].reject(&:blank?).each do |ca_id|
        @product_family_customizable_attributes << ProductFamilyCustomizableAttribute.new(product_family_id: product_family_id, customizable_attribute_id: ca_id)
      end
    elsif product_family_customizable_attribute_params[:product_family_id].is_a?(Array)
      @product_family_customizable_attributes = []
      customizable_attribute_id = product_family_customizable_attribute_params[:customizable_attribute_id]
      product_family_customizable_attribute_params[:product_family_id].reject(&:blank?).each do |pf_id|
        @product_family_customizable_attributes << ProductFamilyCustomizableAttribute.new(product_family_id: pf_id, customizable_attribute_id: customizable_attribute_id)
      end
      #logger.debug ">>>>>>>>>>>>> #{ @product_family_customizable_attributes.inspect }"
    else
      @product_family_customizable_attribute = ProductFamilyCustomizableAttribute.new(product_family_customizable_attribute_params)
    end
  end

  def product_family_customizable_attribute_params
    params.require(:product_family_customizable_attribute).permit(:customizable_attribute_id, :product_family_id, product_family_id: [])
  end
end

