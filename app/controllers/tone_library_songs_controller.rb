class ToneLibrarySongsController < ApplicationController
  before_filter :set_locale
  # GET /tone_library_songs
  # GET /tone_library_songs.xml
  def index
    @tone_library_songs = ToneLibrarySong.order("artist_name, title")

    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @tone_library_songs }
    end
  end
      
  # Utility function to force the download of a patch
  def download
    product = Product.find params[:product_id]
    song = ToneLibrarySong.find params[:tone_library_song_id]
    tone_library_patch = ToneLibraryPatch.find_by_product_id_and_tone_library_song_id(product.id, song.id)
    send_file(tone_library_patch.patch.path, {disposition: 'attachment'})
  end
end
