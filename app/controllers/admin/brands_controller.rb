class Admin::BrandsController < AdminController
  before_action :initialize_brand, only: :create
  load_and_authorize_resource
  # GET /admin/brands
  # GET /admin/brands.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  {
        @brands = Brand.find_each.order(:name)
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
      if @brand.update(brand_params)
        format.html {
          if params["called_from"] == "solutions"
            redirect_to(admin_solutions_path, notice: 'Brand was successfully updated.')
          else
            redirect_to([:admin, @brand], notice: 'Brand was successfully updated.')
          end
        }
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
    params.require(:brand).permit(
      :name,
      :default_website_id,
      :has_effects,
      :has_reviews,
      :has_faqs,
      :has_artists,
      :has_software,
      :has_registered_downloads,
      :has_online_retailers,
      :has_distributors,
      :has_dealers,
      :has_service_centers,
      :default_locale,
      :dealers_from_brand_id,
      :distributors_from_brand_id,
      :logo,
      :news_feed_url,
      :has_market_segments,
      :has_parts_form,
      :has_rma_form,
      :has_training,
      :service_centers_from_brand_id,
      :show_pricing,
      :has_suggested_products,
      :has_blogs,
      :has_audio_demos,
      :has_vintage_repair,
      :employee_store,
      :live_on_this_platform,
      :product_trees,
      :has_us_sales_reps,
      :us_sales_reps_from_brand_id,
      :queue,
      :toolkit,
      :color,
      :has_products,
      :offers_rentals,
      :has_installations,
      :has_product_registrations,
      :has_get_started_pages,
      :has_events,
      :has_solution_pages,
      :show_enterprise_solutions,
      :show_entertainment_solutions,
      :send_contact_form_to_distributors,
      :has_photometrics,
      :dealers_are_us_only,
      :dealers_include_rental_and_service,
      :has_parts_library,
      :send_contact_form_to_regional_support,
      :always_redirect_to_youtube,
      :show_consultant_button,
      :has_product_selector,
      :show_lead_form_on_buy_page,
      :collapse_content,
      :harman_owned,
      :redirect_product_pages_to_parent_brand
    )
  end
end
