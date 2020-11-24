class Admin::ProductBadgesController < AdminController
  before_action :initialize_product_badge, only: :create
  load_and_authorize_resource
  # GET /product_badges
  # GET /product_badges.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_badges }
    end
  end

  # GET /product_badges/1
  # GET /product_badges/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_badge }
    end
  end

  # GET /product_badges/new
  # GET /product_badges/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_badge }
    end
  end

  # GET /product_badges/1/edit
  def edit
  end

  # POST /product_badges
  # POST /product_badges.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_badges.present?
        begin
          @product_badges.each do |product_badge|
            begin
              product_badge.save!
              website.add_log(user: current_user, action: "Added #{product_badge.badge.name} to #{product_badge.product.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_badges/create_error" }
            end
          end
        rescue
          # format.js { render template: "admin/product_badges/create_error" }
        end
      elsif @product_badge.present?
        if @product_badge.save
          format.html { redirect_to([:admin, @product_badge.product], notice: 'Product/badge was successfully created.') }
          format.xml  { render xml: @product_badge, status: :created, location: @product_badge }
          format.js
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_badge.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /product_badges/1
  # PUT /product_badges/1.xml
  def update
    respond_to do |format|
      if @product_badge.update(product_badge_params)
        format.html { redirect_to([:admin, @product_badge.product], notice: 'Product/badge was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_badges/1
  # DELETE /product_badges/1.xml
  def destroy
    @called_from = params[:called_from] || 'product'
    @product_badge.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_badge.product]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_badge
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_badge_params[:product_id].is_a?(Array)
      @product_badges = []
      badge_id = product_badge_params[:badge_id]
      product_badge_params[:product_id].reject(&:blank?).each do |product|
        @product_badges << ProductBadge.new({badge_id: badge_id, product_id: product})
      end
    elsif product_badge_params[:badge_id].is_a?(Array)
      @product_badges = []
      product_id = product_badge_params[:product_id]
      product_badge_params[:badge_id].reject(&:blank?).each do |badge|
        @product_badges << ProductBadge.new({badge_id: badge, product_id: product_id})
      end
    else
      @product_badge = ProductBadge.new(product_badge_params)
    end
  end

  def product_badge_params
    params.require(:product_badge).permit(:badge_id, :product_id)
  end
end
