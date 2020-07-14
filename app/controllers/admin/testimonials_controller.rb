class Admin::TestimonialsController < AdminController
  before_action :initialize_testimonial, only: :create
  load_and_authorize_resource

  # GET /admin/testimonials
  # GET /admin/testimonials.xml
  def index
    @search = website.brand.testimonials.ransack(params[:q])
    @testimonials = @search.result.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @testimonial }
    end
  end

  # GET /admin/testimonial/1
  # GET /admin/testimonial/1.xml
  def show
    @product_family_testimonial = ProductFamilyTestimonial.new(testimonial: @testimonial)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @testimonial }
    end
  end

  # GET /admin/testimonial/new
  # GET /admin/testimonial/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @testimonial }
    end
  end

  # GET /admin/testimonial/1/edit
  def edit
  end

  # POST /admin/testimonial
  # POST /admin/testimonial.xml
  def create
    @testimonial.brand = website.brand
    respond_to do |format|
      if @testimonial.save
        format.html { redirect_to([:admin, @testimonial], notice: 'Testimonial was successfully created.') }
        format.xml  { render xml: @testimonial, status: :created, location: @testimonial }
        website.add_log(user: current_user, action: "Created testimonial: #{@testimonial.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/testimonial/1
  # PUT /admin/testimonial/1.xml
  def update
    respond_to do |format|
      if @testimonial.update(testimonial_params)
        format.html { redirect_to([:admin, @testimonial], notice: 'Testimonial was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated testimonial: #{@testimonial.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @testimonial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/testimonial/1
  # DELETE /admin/testimonial/1.xml
  def destroy
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to(admin_testimonials_index_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted testimonial: #{@testimonial.title}")
  end

  private

  def initialize_testimonial
    @testimonial = Testimonial.new(testimonial_params)
  end

  def testimonial_params
    params.require(:testimonial).permit!
  end
end

