class Admin::ArtistTiersController < AdminController
  load_and_authorize_resource
  # GET /artist_tiers
  # GET /artist_tiers.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist_tiers }
    end
  end

  # GET /artist_tiers/1
  # GET /artist_tiers/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist_tier }
    end
  end

  # GET /artist_tiers/new
  # GET /artist_tiers/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artist_tier }
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
        format.html { redirect_to([:admin, @artist_tier], :notice => 'Artist tier was successfully created.') }
        format.xml  { render :xml => @artist_tier, :status => :created, :location => @artist_tier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist_tier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artist_tiers/1
  # PUT /artist_tiers/1.xml
  def update
    respond_to do |format|
      if @artist_tier.update_attributes(params[:artist_tier])
        format.html { redirect_to([:admin, @artist_tier], :notice => 'Artist tier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist_tier.errors, :status => :unprocessable_entity }
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
  end
end
