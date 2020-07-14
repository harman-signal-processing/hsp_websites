class Admin::BadgesController < AdminController
  before_action :initialize_badge, only: :create
  load_and_authorize_resource

  # GET /badges
  # GET /badges.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @badges }
    end
  end

  # GET /badges/1
  # GET /badges/1.xml
  def show
    @product_badge = ProductBadge.new(badge: @badge)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @badge }
    end
  end

  # GET /badges/new
  # GET /badges/new.xml
  def new
    if params[:product_id]
      @badge.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @badge }
    end
  end

  # GET /badges/1/edit
  def edit
  end

  # POST /badges
  # POST /badges.xml
  def create
    respond_to do |format|
      if @badge.save
        format.html { redirect_to([:admin, @badge], notice: 'Badge was successfully created.') }
        format.xml  { render xml: @badge, status: :created, location: @badge }
        website.add_log(user: current_user, action: "Created badge: #{@badge.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /badges/1
  # PUT /badges/1.xml
  def update
    respond_to do |format|
      if @badge.update(badge_params)
        format.html { redirect_to([:admin, @badge], notice: 'Badge was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated badge: #{@badge.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /badges/1
  # DELETE /badges/1.xml
  def destroy
    @badge.destroy
    respond_to do |format|
      format.html { redirect_to(admin_badges_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted badge: #{@badge.name}")
  end

  private

  def initialize_badge
    @badge = Badge.new(badge_params)
  end

  def badge_params
    params.require(:badge).permit!
  end
end

