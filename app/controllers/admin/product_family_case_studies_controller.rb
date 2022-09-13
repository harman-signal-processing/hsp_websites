class Admin::ProductFamilyCaseStudiesController < AdminController
  before_action :initialize_product_family_case_study, only: :create
  load_and_authorize_resource except: [:update_order]
  skip_authorization_check only: [:update_order]

  # GET /product_family_case_studies
  # GET /product_family_case_studies.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_case_studies }
    end
  end

  # GET /product_family_case_studies/1
  # GET /product_family_case_studies/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_case_study }
    end
  end

  # GET /product_family_case_studies/new
  # GET /product_family_case_studies/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_case_study }
    end
  end

  # GET /product_family_case_studies/1/edit
  def edit
  end

  # POST /product_family_case_studies
  # POST /product_family_case_studies.xml
  def create
    @called_from = params[:called_from] || 'product_family'
    respond_to do |format|
      if @product_family_case_study.save
        format.html { redirect_to([:admin, @product_family_case_study.product_family], notice: 'Product Family Case Study was successfully created.') }
        format.xml  { render xml: @product_family_case_study, status: :created, location: @product_family_case_study }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family_case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_family_case_studies/1
  # PUT /product_family_case_studies/1.xml
  def update
    respond_to do |format|
      if @product_family_case_study.update(product_family_case_study_params)
        format.html { redirect_to([:admin, @product_family_case_study.product_family], notice: 'Product Family Case Study was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_family_case_studies/update_order
  def update_order
    update_list_order(ProductFamilyCaseStudy, params["product_family_case_study"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product family case studies")
  end

  # DELETE /product_family_case_studies/1
  # DELETE /product_family_case_studies/1.xml
  def destroy
    @product_family_case_study.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_family_case_study.product_family]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_family_case_study
    @product_family_case_study = ProductFamilyCaseStudy.new(product_family_case_study_params)
  end

  def product_family_case_study_params
    params.require(:product_family_case_study).permit(:product_family_id, :case_study_id, :position)
  end
end
