class Admin::BrandSpecificationForComparisonsController < AdminController
  before_action :initialize_bsfc, only: :create
  load_and_authorize_resource

  # GET /admin/specifications
  # GET /admin/specifications.xml
  def index
    @brand_specification_for_comparisons = website.brand.specification_for_comparisons
    @brand_specification_for_comparison = BrandSpecificationForComparison.new
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @brand_specification_for_comparisons }
    end
  end

  # POST /admin/specifications
  # POST /admin/specifications.xml
  def create
    respond_to do |format|
      if @brand_specification_for_comparison.save
        format.html { redirect_to(action: :index, notice: 'Specification was successfully added.') }
        format.js
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /admin/brand_specifications_for_comparison/1
  # DELETE /admin/brand_specifications_for_comparison/1.xml
  def destroy
    @brand_specification_for_comparison.destroy
    respond_to do |format|
      format.html { redirect_to(admin_brand_specification_for_comparisons_url) }
      format.js
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted #{@brand_specification_for_comparison.specification.name} from product comparisons.")
  end

  private

  def initialize_bsfc
    @brand_specification_for_comparison = BrandSpecificationForComparison.new(brand_specification_for_comparison_params)
    @brand_specification_for_comparison.brand = website.brand
  end

  def brand_specification_for_comparison_params
    params.require(:brand_specification_for_comparison).permit!
  end

end

