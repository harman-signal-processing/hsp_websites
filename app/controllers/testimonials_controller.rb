class TestimonialsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  # Index action is dependent on there being a product family to
  # pull related testimonials from
  def index
    @product_family = ProductFamily.find(params[:product_family_id])
    @testimonials = @product_family.testimonials
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @testimonials }
    end
  end

  # GET /news/1
  # GET /news/1.xml
  def show
    if !website.testimonials.include?(@testimonial)
      redirect_to root_path, status: :moved_permanently and return
    end
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @testimonial }
    end
  end
  protected

  def ensure_best_url
    @testimonial = Testimonial.where(cached_slug: params[:id]).first || Testimonial.find(params[:id])
    # redirect_to @testimonial, status: :moved_permanently unless @testimonial.friendly_id_status.best?
  end
end
