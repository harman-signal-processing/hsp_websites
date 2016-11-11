class Admin::ProductSolutionsController < AdminController
  before_action :load_solution
  before_filter :initialize_product_solution, only: :create
  load_and_authorize_resource

  # GET /admin/product_solutions
  # GET /admin/product_solutions.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_solutions }
    end
  end

  # GET /admin/product_solutions/1
  # GET /admin/product_solutions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_solution }
    end
  end

  # GET /admin/product_solutions/new
  # GET /admin/product_solutions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_solution }
    end
  end

  # GET /admin/product_solutions/1/edit
  def edit
  end

  # POST /admin/product_solutions
  # POST /admin/product_solutions.xml
  def create
    @called_from = params[:called_from]
    @product_solution.solution = @solution
    @products = website.products - @solution.products - [@product_solution.product]
    respond_to do |format|
      if @product_solution.save
        format.html { redirect_to([:admin, @solution], notice: 'Product/solution was successfully created.') }
        format.xml  { render xml: @product_solution, status: :created, location: @product_solution }
        format.js
        website.add_log(user: current_user, action: "Added #{@product_solution.product.name} to solution")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_solution.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /admin/product_solutions/1
  # PUT /admin/product_solutions/1.xml
  def update
    respond_to do |format|
      if @product_solution.update_attributes(product_solution_params)
        format.html { redirect_to([:admin, @solution], notice: 'Product/Solution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_solutions/1
  # DELETE /admin/product_solutions/1.xml
  def destroy
    @product_solution.destroy
    @products = website.products - @solution.products
    respond_to do |format|
      format.html { redirect_to([:admin, @solution]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unlinked solution/product #{@product_solution.product.name}, #{@product_solution.solution.name}")
  end

  private

  def initialize_product_solution
    @product_solution = ProductSolution.new(product_solution_params)
  end

  def load_solution
    @solution = Solution.find(params[:solution_id])
  end

  def product_solution_params
    params.require(:product_solution).permit!
  end
end
