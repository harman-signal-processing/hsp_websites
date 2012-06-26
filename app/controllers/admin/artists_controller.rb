class Admin::ArtistsController < AdminController
  load_and_authorize_resource
  # GET /admin/artists
  # GET /admin/artists.xml
  def index
    @featured_artists = website.artists.where(:featured => true).sort_by(&:position)
    @unapproved_artists = @artists.where("approver_id IS NULL OR approver_id = ''").order("name")
    @the_rest = @artists - @featured_artists - @unapproved_artists
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  # GET /admin/artists/1
  # GET /admin/artists/1.xml
  def show
    @artist_product = ArtistProduct.new(:artist => @artist)
    @artist_brand = ArtistBrand.find_or_initialize_by_artist_id_and_brand_id(@artist.id, website.brand_id)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  # GET /admin/artists/new
  # GET /admin/artists/new.xml
  def new
    @artist.initial_brand = website.brand
    @artist_brand = ArtistBrand.new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  # GET /admin/artists/1/edit
  def edit
    @artist.approved = !!!(@artist.approver_id.blank?)
    @artist_brand = ArtistBrand.find_or_create_by_artist_id_and_brand_id(@artist.id, website.brand_id)
  end

  # POST /admin/artists
  # POST /admin/artists.xml
  def create
    @artist.skip_unapproval = true
    if params[:artist][:approved]
      @artist.approver_id = current_user.id
    end
    @artist.initial_brand = website.brand
    @artist.skip_confirmation!
    @artist_brand = ArtistBrand.new(params[:artist_brand])
    respond_to do |format|
      if @artist.save
        @artist_brand.artist_id = @artist.id 
        @artist_brand.brand_id = website.brand_id
        @artist_brand.save
        format.html { redirect_to([:admin, @artist], :notice => 'Artist was successfully created.') }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # PUT /admin/product_families/update_order
  def update_order
    update_list_order(Artist, params["artists"])
    render :nothing=>true
  end
  
  # POST /admin/artists/1/reset_password
  def reset_password
    new_password = "#{website.brand_name.gsub(/\s/, "")}123"
    @artist.password = new_password
    @artist.password_confirmation = @artist.password
    respond_to do |format|
      if @artist.save
        format.html { redirect_to([:admin, @artist], :notice => "Password was reset to: #{new_password}")}
        format.xml { head :ok }
      end
    end
  end

  # PUT /admin/artists/1
  # PUT /admin/artists/1.xml
  def update
    params[:artist][:skip_unapproval] = true
    if params[:artist][:approved]
      params[:artist][:approver_id] = current_user.id
    end
    @artist_brand = ArtistBrand.find_or_create_by_artist_id_and_brand_id(@artist.id, website.brand_id)
    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        @artist_brand.update_attributes(params[:artist_brand])
        format.html { redirect_to([:admin, @artist], :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/artists/1
  # DELETE /admin/artists/1.xml
  def destroy
    if @artist.artist_brands.size <= 1
      @artist.destroy
    else
      @artist.artist_brands.each do |ab|
        ab.destroy if ab.brand == website.brand
      end
    end
    respond_to do |format|
      format.html { redirect_to(admin_artists_url) }
      format.xml  { head :ok }
    end
  end
end
