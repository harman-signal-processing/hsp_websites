class Admin::ProductFamilyTestimonialsController < AdminController
  before_action :initialize_product_family_testimonial, only: :create
  load_and_authorize_resource

  # GET /admin/product_family_testimonials
  # GET /admin/product_family_testimonials.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_testimonials }
    end
  end

  # GET /admin/product_family_testimonials/1
  # GET /admin/product_family_testimonials/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_testimonial }
    end
  end

  # GET /admin/product_family_testimonials/new
  # GET /admin/product_family_testimonials/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_testimonial }
    end
  end

  # GET /admin/product_family_testimonials/1/edit
  def edit
  end

  # POST /admin/product_family_testimonials
  # POST /admin/product_family_testimonials.xml
  def create
    @called_from = params[:called_from]
    respond_to do |format|

      if @product_family_testimonials.present?
        begin
          @product_family_testimonials.each do |product_family_testimonial|
            begin
              product_family_testimonial.save!
              website.add_log(user: current_user, action: "Added #{product_family_testimonial.testimonial.title} to #{product_family_testimonial.product_family.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_family_testimonials/create_error" }
            end
          end  #  @product_family_testimonials.each do |product_family_testimonial|
        rescue
          # format.js { render template: "admin/product_family_testimonials/create_error" }
        end
      else
        if @product_family_testimonial.save
          format.html { redirect_to([:admin, @product_family_testimonial.product_family], notice: 'Product Family Testimonial was successfully created.') }
          format.xml  { render xml: @product_family_testimonial, status: :created, location: @product_family_testimonial }
          format.js
          website.add_log(user: current_user, action: "Added #{@product_family_testimonial.product_family.name} to testimonial")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_family_testimonial.errors, status: :unprocessable_entity }
          format.js { render plain: "Error"}
        end
      end
    end
  end

  # PUT /admin/product_family_testimonials/1
  # PUT /admin/product_family_testimonials/1.xml
  def update
    respond_to do |format|
      if @product_family_testimonial.update(product_family_testimonial_params)
        format.html { redirect_to([:admin, @product_family_testimonial.product_family], notice: 'Product Family Testimonial was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_family_testimonials/1
  # DELETE /admin/product_family_testimonials/1.xml
  def destroy
    @called_from = params[:called_from]
    @product_family_testimonial.destroy
    respond_to do |format|
      format.html { redirect_to(admin_testimonials_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unlinked testimonial/product family #{@product_family_testimonial.product_family.name}, #{@product_family_testimonial.testimonial.title}")
  end

  private

  def initialize_product_family_testimonial
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_family_testimonial_params[:product_family_id].is_a?(Array)
      @product_family_testimonials = []
      testimonial_id = product_family_testimonial_params[:testimonial_id]
      product_family_testimonial_params[:product_family_id].reject(&:blank?).each do |product_family|
        @product_family_testimonials << ProductFamilyTestimonial.new({testimonial_id: testimonial_id, product_family_id: product_family})
      end
    elsif product_family_testimonial_params[:testimonial_id].is_a?(Array)
      @product_family_testimonials = []
      product_family_id = product_family_testimonial_params[:product_family_id]
      product_family_testimonial_params[:testimonial_id].reject(&:blank?).each do |testimonial|
        @product_family_testimonials << ProductFamilyTestimonial.new({testimonial_id: testimonial, product_family_id: product_family_id})
      end
    else
      @product_family_testimonial = ProductFamilyTestimonial.new(product_family_testimonial_params)
    end
  end

  def product_family_testimonial_params
    params.require(:product_family_testimonial).permit(:product_family_id, :testimonial_id, :position)
  end
end

