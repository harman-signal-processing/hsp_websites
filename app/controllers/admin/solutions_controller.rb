class Admin::SolutionsController < AdminController
  before_action :initialize_solution, only: :create
  load_and_authorize_resource

  # GET /admin/solutions
  # GET /admin/solutions.xml
  def index
    @solutions = Solution.all
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @solutions }
    end
  end

  # GET /admin/solutions/1
  # GET /admin/solutions/1.xml
  def show
    @product_solution = ProductSolution.new(solution: @solution)
    @all_products = [[website.brand.name, website.products]]
    Brand.where(live_on_this_platform: true).where.not(id: website.brand_id).order("UPPER(name)").each do |brand|
      if Product.where(brand_id: brand.id).count > 0
        @all_products << [brand.name, Product.where(product_status_id: ProductStatus.current_ids, brand_id: brand.id).order("name")]
      end
    end
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @solution }
    end
  end

  # GET /admin/solutions/new
  # GET /admin/solutions/new.xml
  def new
    @solution.brands << website.brand
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @solution }
    end
  end

  # GET /admin/solutions/1/edit
  def edit
  end

  # POST /admin/solutions
  # POST /admin/solutions.xml
  def create
    respond_to do |format|
      if @solution.save
        format.html { redirect_to([:admin, @solution], notice: 'Solution was successfully created.') }
        format.xml  { render xml: @solution, status: :created, location: @solution }
        website.add_log(user: current_user, action: "Created a solution: #{@solution.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/solutions/1
  # PUT /admin/solutions/1.xml
  def update
    respond_to do |format|
      if @solution.update_attributes(solution_params)
        format.html { redirect_to([:admin, @solution], notice: 'Solution was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated solution #{@solution.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/solutions/1
  # DELETE /admin/solutions/1.xml
  def destroy
    @solution.destroy
    respond_to do |format|
      format.html { redirect_to(admin_solutions_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted solution #{@solution.name}")
  end

  private

  def initialize_solution
    @solution = Solution.new(solution_params)
  end

  def solution_params
    params.require(:solution).permit!
  end
end
