module ArtistsHelper
  
  # Generates a slideshow based on a provided list of slides and
  # an optional duration. Each slide should be an instance of Artist.
  # 
  # (Note: if only one slide is in the Array, then a single image
  # is rendered without the animation javascript.)
  #
  def artist_slideshow(options={})
    default_options = { duration: 7000, slides: [], transition: "toggle", size: "940x400" }
    options = default_options.merge(options)
    html = ''
    if options[:slides].size > 1
      html += artist_slideshow_controls(options)
      options[:slides].each_with_index do |slide,i|
        html += artist_slideshow_frame(slide, i, options[:size])
      end
      raw(html + javascript_tag("start_slideshow(1, #{options[:slides].size}, #{options[:duration]}, '#{options[:transition]}');"))
    else
      raw(artist_slideshow_frame(options[:slides].first, 0, options[:size]))
    end
  end
  
  # Used by the "artist_slideshow" method to render a frame.
  def artist_slideshow_frame(artist, position=0, size)
    hidden = (position == 0) ? "" : "display:none"
    artist_brand = artist.artist_brands.where(brand_id: website.brand_id).first
    content_tag(:div, id: "slideshow_#{(position + 1)}", class: "slideshow_frame", style: hidden) do
        link_to(image_tag(artist.artist_photo.url(:feature), size: size), artist) +
        content_tag(:div, class:"description") do
          content_tag(:h2) do
            link_to(artist.name, artist)
          end + 
          content_tag(:p, artist_brand.intro.to_s.html_safe)
        end
    end
  end
  
  # Controls for the generated slideshow
  def artist_slideshow_controls(options={})
    default_options = { duration: 6000, slides: [] }
    options = default_options.merge(options)
    unless options[:slides].size <= 1
      divs = ""
      (1..options[:slides].size).to_a.reverse.each do |i|
        divs += link_to_function(i, 
                  "stop_slideshow(#{i}, #{options[:slides].size});", 
                  id: "slideshow_control_#{i}",
                  class: (i==1) ? "current_button" : "")
      end
      hidden = (options[:slides].size > 5) ? "display:none" : "" # too big
      content_tag(:div, id: "slideshow_controls", style: hidden) do
        raw(divs)
      end
    end
  end
  
  def list_artists_touring_with(product)
    artists = []
    product.artists_on_tour.each do |artist|
      if artist.featured
        artists << link_to(artist.name, artist)
      else
        artists << artist.name
      end
    end
    raw(artists.join(", "))
  end
  
  def list_products_used_by(artist)
    raw(artist.products.collect{|p| link_to(p.name, p)}.join(", "))
  end
  
end
