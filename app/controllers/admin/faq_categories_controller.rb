class Admin::FaqCategoriesController < AdminController
  before_action :initialize_faq_category, only: :create
  load_and_authorize_resource
  # GET /faq_categories
  # GET /faq_categories.xml
  def index
    redirect_to admin_faqs_path
  end

  # GET /faq_categories/1
  # GET /faq_categories/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @faq_category }
    end
  end

  # GET /faq_categories/new
  # GET /faq_categories/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @faq_category }
    end
  end

  # GET /faq_categories/1/edit
  def edit
  end

  # POST /faq_categories
  # POST /faq_categories.xml
  def create
    respond_to do |format|
      @faq_category.brand_id = website.brand_id
      if @faq_category.save
        format.html { redirect_to([:admin, @faq_category], notice: 'Category was successfully created.') }
        format.xml  { render xml: @faq_category, status: :created, location: @faq_category }
        website.add_log(user: current_user, action: "Created FAQ Category: #{@faq_category.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @faq_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /faq_categories/1
  # PUT /faq_categories/1.xml
  def update
    respond_to do |format|
      if @faq_category.update_attributes(faq_category_params)
        format.html { redirect_to([:admin, @faq_category], notice: 'Category was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated FAQ Category: #{@faq_category.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @faq_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faq_categories/1
  # DELETE /faq_categories/1.xml
  def destroy
    @faq_category.destroy
    respond_to do |format|
      format.html { redirect_to(admin_faqs_path, notice: "The category was deleted.") }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted FAQ Category: #{@faq_category.name}")
  end

  private

  def initialize_faq_category
    @faq = FaqCategory.new(faq_category_params)
  end

  def faq_category_params
    params.require(:faq_category).permit!
  end
end
