class Admin::BrandsController < AdminController
  before_filter :initialize_brand, only: :create
  load_and_authorize_resource
  # GET /admin/brands
  # GET /admin/brands.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @brands = Brand.all.order(:name)
        render xml: @brands 
      }
    end
  end

  # GET /admin/brands/1
  # GET /admin/brands/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @brand }
    end
  end

  # GET /admin/brands/new
  # GET /admin/brands/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @brand }
    end
  end

  # GET /admin/brands/1/edit
  def edit
  end

  # POST /admin/brands
  # POST /admin/brands.xml
  def create
    respond_to do |format|
      if @brand.save
        format.html { redirect_to([:admin, @brand], notice: 'Brand was successfully created.') }
        format.xml  { render xml: @brand, status: :created, location: @brand }
        website.add_log(user: current_user, action: "Created brand: #{@brand.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/brands/1
  # PUT /admin/brands/1.xml
  def update
    respond_to do |format|
      if @brand.update_attributes(brand_params)
        format.html { redirect_to([:admin, @brand], notice: 'Brand was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated brand: #{@brand.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/brands/1
  # DELETE /admin/brands/1.xml
  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to(admin_brands_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted brand: #{@brand.name}")
  end

  private

  def initialize_brand
    @brand = Brand.new(brand_params)
  end

  def brand_params
    params.require(:brand).permit!
  end
end
