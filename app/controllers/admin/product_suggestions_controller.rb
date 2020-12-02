class Admin::ProductSuggestionsController < ApplicationController
  before_action :initialize_product_suggestion, only: :create
  load_and_authorize_resource except: [:update_order]
  skip_authorization_check only: [:update_order]

  # GET /admin/product_suggestions
  # GET /admin/product_suggestions.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_suggestions }
    end
  end

  # GET /admin/product_suggestions/1
  # GET /admin/product_suggestions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_suggestion }
    end
  end

  # GET /admin/product_suggestions/new
  # GET /admin/product_suggestions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_suggestion }
    end
  end

  # GET /admin/product_suggestions/1/edit
  def edit
  end

  # POST /admin/product_suggestions
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      @product_suggestions.each(&:save)
      format.js
    end
  end

  # PUT /admin/product_suggestions/1
  # PUT /admin/product_suggestions/1.xml
  def update
    respond_to do |format|
      if @product_suggestion.update(product_suggestion_params)
        format.html { redirect_to([:admin, @product_suggestion], notice: 'Product Suggestion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_order
    update_list_order(ProductSuggestion,  params["product_suggestion"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted product suggestions")
  end

  # DELETE /admin/product_suggestions/1
  # DELETE /admin/product_suggestions/1.xml
  def destroy
    @product_suggestion.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_suggestions_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed suggested product: #{Product.find(@product_suggestion.suggested_product_id).name} from #{@product_suggestion.product.name}")
  end

  private

  def initialize_product_suggestion
    @product_suggestions = []
    product_id = product_suggestion_params[:product_id]
    product_suggestion_params[:suggested_product_id].reject(&:blank?).each do |suggested_product|
      @product_suggestions << ProductSuggestion.new({product_id: product_id, suggested_product_id: suggested_product})
    end
  end

  def product_suggestion_params
    params.require(:product_suggestion).permit(:product_id, :suggested_product_id, :position, product_id: [], suggested_product_id: [])
  end
end
