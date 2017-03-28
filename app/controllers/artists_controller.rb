class ArtistsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  # GET /artists
  # GET /artists.xml
  def index
    @featured_artists = Artist.all_for_website(website, "position").where(featured: true)
    respond_to do |format|
      if website.brand.has_artists? # && @featured_artists.size > 0
        format.html { render_template }# index.html.erb
      else
        format.html { redirect_to root_path }
      end
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    @artist = Artist.find(params[:id])
    unless @artist.belongs_to_this_brand?(website)
      redirect_to artists_path and return
    end
    if @artist.featured || @artist.artist_tier.show_on_artist_page?
      respond_to do |format|
        format.html { render_template } # show.html.erb
        # format.xml  { render xml: @artist }
      end
    else
      redirect_to all_artists_path(letter: @artist.name.match(/\w/).to_s.downcase) and return false
    end
  end

  # GET /artists/list
  # GET /artists/list.xml
  def list
    redirect_to action: "index"
  end

  # GET /artists/touring
  # GET /artists/touring.xml
  def touring
    @products = Product.on_tour(website)
    respond_to do |format|
      format.html { render_template } # touring.html.erb
      # format.xml  { render xml: @products }
    end
  end

  # Get /artists/become_an_artist
  def become
    render_template
  end

  # Alphabetical list of artists
  def all
    params[:letter] ||= "a"
    params[:letter] = params[:letter] + "a" # to ensure there's something to match below...
    params[:letter] = params[:letter].downcase.match(/\w{1}/).to_s
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
    render_template
  end

  protected

  # :nocov:
  def ensure_best_url
    @artist = Artist.where(cached_slug: params[:id]).first || Artist.find(params[:id])
    # redirect_to @artist, status: :moved_permanently unless @artist.friendly_id_status.best?
  end
  # :nocov:

end
