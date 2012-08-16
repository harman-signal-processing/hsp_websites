class Admin::ProductSuggestionsController < ApplicationController
  load_and_authorize_resource
  
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
  # POST /admin/product_suggestions.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_suggestion.save
        format.html { redirect_to([:admin, @product_suggestion], notice: 'Product Suggestion was successfully created.') }
        format.xml  { render xml: @product_suggestion, status: :created, location: @product_suggestion }
        format.js
        website.add_log(user: current_user, action: "Created a product suggestion for #{@product_suggestion.product.name} (suggesting #{@product_suggestion.suggested_product.name})")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_suggestion.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /admin/product_suggestions/1
  # PUT /admin/product_suggestions/1.xml
  def update
    respond_to do |format|
      if @product_suggestion.update_attributes(params[:product_suggestion])
        format.html { redirect_to([:admin, @product_suggestion], notice: 'Product Suggestion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_suggestion.errors, status: :unprocessable_entity }
      end
    end
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
    website.add_log(user: current_user, action: "Removed suggested product from #{@product_suggestion.product.name}")
  end
end
