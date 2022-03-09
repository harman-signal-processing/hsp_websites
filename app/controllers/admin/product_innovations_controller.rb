class Admin::ProductInnovationsController < AdminController
  before_action :initialize_product_innovation, only: :create
  load_and_authorize_resource

  # GET /admin/product_innovations
  # GET /admin/product_innovations.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_innovations }
    end
  end

  # GET /admin/product_innovations/1
  # GET /admin/product_innovations/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_innovation }
    end
  end

  # GET /admin/product_innovations/new
  # GET /admin/product_innovations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_innovation }
    end
  end

  # GET /admin/product_innovations/1/edit
  def edit
  end

  # POST /admin/product_innovations
  # POST /admin/product_innovations.xml
  def create
    @called_from = params[:called_from]
    respond_to do |format|

      if @product_innovations.present?
        begin
          @product_innovations.each do |product_innovation|
            begin
              product_innovation.save!
              website.add_log(user: current_user, action: "Added #{product_innovation.product.name} to #{product_innovation.innovation.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_innovations/create_error" }
            end
          end  #  @product_innovations.each do |product_innovation|
        rescue
          # format.js { render template: "admin/product_innovations/create_error" }
        end
      else
        if @product_innovation.save
          format.html { redirect_to([:admin, @product_innovation], notice: 'Product Innovation was successfully created.') }
          format.xml  { render xml: @product_innovation, status: :created, location: @product_innovation }
          format.js
          website.add_log(user: current_user, action: "Added #{@product_innovation.product.name} to innovation #{@product_innovation.innovation.name}.")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_innovation.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end
  end

  # PUT /admin/product_innovations/1
  # PUT /admin/product_innovations/1.xml
  def update
    respond_to do |format|
      if @product_innovation.update(product_innovation_params)
        format.html { redirect_to([:admin, @product_innovation], notice: 'Product Innovation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_innovation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_innovations/1
  # DELETE /admin/product_innovations/1.xml
  def destroy
    @called_from = params[:called_from]
    @product_innovation.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_innovations_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unlinked innovation/product #{@product_innovation.product.name}, #{@product_innovation.innovation.name}")
  end

  private

  def initialize_product_innovation
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_innovation_params[:product_id].is_a?(Array)
      @product_innovations = []
      innovation_id = product_innovation_params[:innovation_id]
      product_innovation_params[:product_id].reject(&:blank?).each do |product|
        @product_innovations << ProductInnovation.new({innovation_id: innovation_id, product_id: product})
      end
    else
      @product_innovation = ProductInnovation.new(product_innovation_params)
    end
  end

  def product_innovation_params
    params.require(:product_innovation).permit(:product_id, :innovation_id, product_id: [])
  end
end
