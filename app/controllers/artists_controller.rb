class ArtistsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, :only => :show
  
  # GET /artists
  # GET /artists.xml
  def index
    respond_to do |format|
      @featured_artists = website.artists.where(:featured => true).all.sort_by(&:position)
      @artist_tiers = ArtistTier.for_artist_page
      if website.has_artists? && @featured_artists.size > 0
        format.html { render_template }# index.html.erb
        format.xml  { render :xml => @featured_artists }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    @artist = Artist.find(params[:id])
    if !website.artists.include?(@artist)
      redirect_to artists_path and return
    end
    if @artist.featured || @artist.artist_tier.show_on_artist_page?
      respond_to do |format|
        format.html { render_template } # show.html.erb
        format.xml  { render :xml => @artist }
      end
    else
      redirect_to artists_path(:anchor => "artist_#{@artist.id}") and return
    end
  end
  
  # GET /artists/list
  # GET /artists/list.xml
  def list
    redirect_to :action => "index"
  end
  
  # GET /artists/touring
  # GET /artists/touring.xml
  def touring
    @products = Product.on_tour(website)
    respond_to do |format|
      format.html { render_template } # touring.html.erb
      format.xml  { render :xml => @products }
    end    
  end
  
  # Get /artists/become_an_artist
  def become
    render_template
  end
  
  # Alphabetical list of artists
  def all
    params[:letter] ||= "a"
    params[:letter] = params[:letter].downcase.match(/^\w{1}/).to_s
    @all_artists = {}
    ("a".."z").each do |letter|
      @all_artists[letter] = []
    end
    Artist.all_for_website(website).each do |artist|
      artist.name.downcase.match(/^(\w)/)
      first_letter = $1 || 'z'
      @all_artists[first_letter] << artist
    end
    @artists = @all_artists[params[:letter]]
  end
  
  protected
  
  def ensure_best_url
    @artist = Artist.find(params[:id])
    redirect_to @artist, :status => :moved_permanently unless @artist.friendly_id_status.best?
  end

end
