class Admin::ArtistTiersController < AdminController
  before_action :initialize_artist_tier, only: :create
  load_and_authorize_resource

  # GET /artist_tiers
  # GET /artist_tiers.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @artist_tiers }
    end
  end

  # GET /artist_tiers/1
  # GET /artist_tiers/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @artist_tier }
    end
  end

  # GET /artist_tiers/new
  # GET /artist_tiers/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @artist_tier }
    end
  end

  # GET /artist_tiers/1/edit
  def edit
  end

  # POST /artist_tiers
  # POST /artist_tiers.xml
  def create
    respond_to do |format|
      if @artist_tier.save
        format.html { redirect_to([:admin, @artist_tier], notice: 'Artist tier was successfully created.') }
        format.xml  { render xml: @artist_tier, status: :created, location: @artist_tier }
        website.add_log(user: current_user, action: "Created artist tier #{@artist_tier.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @artist_tier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /artist_tiers/1
  # PUT /artist_tiers/1.xml
  def update
    respond_to do |format|
      if @artist_tier.update_attributes(artist_tier_params)
        format.html { redirect_to([:admin, @artist_tier], notice: 'Artist tier was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated artist tier #{@artist_tier.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @artist_tier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artist_tiers/1
  # DELETE /artist_tiers/1.xml
  def destroy
    @artist_tier.destroy
    respond_to do |format|
      format.html { redirect_to(admin_artist_tiers_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted artist tier #{@artist_tier.name}")
  end

  private

  def initialize_artist_tier
    @artist_tier = ArtistTier.new(artist_tier_params)
  end

  def artist_tier_params
    params.require(:artist_tier).permit!
  end
end
