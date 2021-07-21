class Admin::CustomizableAttributesController < AdminController
  before_action :initialize_customizable_attribute, only: :create
  load_and_authorize_resource

  # GET /customizable_attributes
  # GET /customizable_attributes.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @customizable_attributes }
    end
  end

  # GET /customizable_attributes/1
  # GET /customizable_attributes/1.xml
  def show
    @product_family_customizable_attribute = ProductFamilyCustomizableAttribute.new(
      customizable_attribute: @customizable_attribute
    )
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @customizable_attribute }
    end
  end

  # GET /customizable_attributes/new
  # GET /customizable_attributes/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @customizable_attribute }
    end
  end

  # GET /customizable_attributes/1/edit
  def edit
  end

  # POST /customizable_attributes
  # POST /customizable_attributes.xml
  def create
    respond_to do |format|
      if @customizable_attribute.save
        format.html { redirect_to([:admin, @customizable_attribute], notice: 'Customizable Attribute was successfully created.') }
        format.xml  { render xml: @customizable_attribute, status: :created, location: @customizable_attribute }
        website.add_log(user: current_user, action: "Created customizable attribute: #{@customizable_attribute.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @customizable_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customizable_attributes/1
  # PUT /customizable_attributes/1.xml
  def update
    respond_to do |format|
      if @customizable_attribute.update(customizable_attribute_params)
        format.html { redirect_to([:admin, @customizable_attribute], notice: 'Customizable Attribute was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated customizable attribute: #{@customizable_attribute.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @customizable_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customizable_attributes/1
  # DELETE /customizable_attributes/1.xml
  def destroy
    @customizable_attribute.destroy
    respond_to do |format|
      format.html { redirect_to(admin_customizable_attributes_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted customizable attribute: #{@customizable_attribute.name}")
  end

  private

  def initialize_customizable_attribute
    @customizable_attribute = CustomizableAttribute.new(customizable_attribute_params)
  end

  def customizable_attribute_params
    params.require(:customizable_attribute).permit(:name)
  end
end

