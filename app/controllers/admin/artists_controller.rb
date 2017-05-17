class Admin::ArtistsController < AdminController
  before_action :initialize_artist, only: :create
  load_and_authorize_resource

  # GET /admin/artists
  # GET /admin/artists.xml
  def index
    @search = Artist.ransack(params[:q])
    if params[:q]
      @artists_search_results = @search.result.order(:name)
    else
      @featured_artists = website.artists.where(featured: true).sort_by(&:position)
      @unapproved_artists = @artists.where("approver_id IS NULL OR approver_id = ''").order("UPPER('name')")
      @the_rest = @artists - @featured_artists - @unapproved_artists
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @artists }
    end
  end

  # GET /admin/artists/1
  # GET /admin/artists/1.xml
  def show
    @artist_product = ArtistProduct.new(artist: @artist)
    @artist_brand = ArtistBrand.where(artist_id: @artist.id, brand_id: website.brand_id).first_or_initialize
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @artist }
    end
  end

  # GET /admin/artists/new
  # GET /admin/artists/new.xml
  def new
    @artist.initial_brand = website.brand
    @artist_brand = ArtistBrand.new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @artist }
    end
  end

  # GET /admin/artists/1/edit
  def edit
    @artist.approved = !!!(@artist.approver_id.blank?)
    @artist_brand = ArtistBrand.where(artist_id: @artist.id, brand_id: website.brand_id).first_or_create
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
    @artist_brand = ArtistBrand.new(params.require(:artist_brand).permit!)
    respond_to do |format|
      if @artist.save
        @artist_brand.artist_id = @artist.id 
        @artist_brand.brand_id = website.brand_id
        @artist_brand.save
        format.html { redirect_to([:admin, @artist], notice: 'Artist was successfully created.') }
        format.xml  { render xml: @artist, status: :created, location: @artist }
        website.add_log(user: current_user, action: "Created artist #{@artist.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @artist.errors, status: :unprocessable_entity }
      end
    end
  end
    
  # PUT /admin/product_families/update_order
  def update_order
    update_list_order(Artist, params["artist"])
    head :ok
    website.add_log(user: current_user, action: "Changed the artist sort order")
  end
  
  # POST /admin/artists/1/reset_password
  def reset_password
    new_password = "#{website.brand_name.gsub(/\s/, "")}123"
    @artist.password = new_password
    @artist.password_confirmation = @artist.password
    respond_to do |format|
      if @artist.save
        format.html { redirect_to([:admin, @artist], notice: "Password was reset to: #{new_password}")}
        format.xml { head :ok }
        website.add_log(user: current_user, action: "Reset password for artist #{@artist.name}")
      end
    end
  end

  # PUT /admin/artists/1
  # PUT /admin/artists/1.xml
  def update
    # render text: params[:artist].to_yaml
    params[:artist][:skip_unapproval] = true
    if !!(params[:artist][:approved].to_i > 0)
      params[:artist][:approver_id] = current_user.id
    else
      params[:artist][:approver_id] = nil
    end
    @artist_brand = ArtistBrand.where(artist_id: @artist.id, brand_id: website.brand_id).first_or_create
    respond_to do |format|
      if @artist.update_attributes(artist_params)
        @artist_brand.update_attributes(params.require(:artist_brand).permit!)
        format.html { redirect_to([:admin, @artist], notice: 'Artist was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated artist: #{@artist.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @artist.errors, status: :unprocessable_entity }
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
    website.add_log(user: current_user, action: "Deleted artist: #{@artist.name}")
  end

  private

  def initialize_artist
    @artist = Artist.new(artist_params)
  end

  def artist_params
    params.require(:artist).permit!
  end
end
