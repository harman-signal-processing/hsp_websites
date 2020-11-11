module ManufacturerPartnersHelper

  # Generates a slideshow using Zurb's Orbit. Accepts the same options as my
  # manually-built slideshow for backwards compatibility. Most options are
  # ignored.
  #
  def mp_orbit_slideshow(options={})
    default_options = { duration: 7000, animation: 'slide', slide_number: false, navigation_arrows: true, slides: [] }
    options = default_options.merge options

    orbit_options = [
      "resume_on_mouseout:true",
      "timer_speed:#{options[:duration]}",
      "slide_number:#{options[:slide_number]}",
      "animation_speed:#{(options[:duration] / 12).to_i}",
      "animation:#{options[:transition]}",
      "navigation_arrows:#{options[:navigation_arrows]}"
    ]
    if options[:slides].length == 1 || options[:slides].length > 7
      orbit_options << "bullets:false"
    end
    if options[:slides].length == 1
      orbit_options << "timer:false"
    end

    frames = ""
    options[:slides].each_with_index do |slide, i|
      frames += orbit_slideshow_frame(slide, i)
    end
    
    content_tag(:div, class: "slideshow-wrapper") do
      content_tag(:div, "", class: "preloader") +
      content_tag(:ul,
        frames.html_safe,
        data: {
          orbit: true,
          options: orbit_options.join(";")
        }
      )  #  content_tag(:ul
    end  #  content_tag(:div, class: "slideshow-wrapper") do

  end  #  def mp_orbit_slideshow(options={})

  # Used by the "mp_orbit_slideshow" method to render a frame
  def orbit_slideshow_frame(slide, position=0)
    link_options = {}
    slide_content = partner_slide(slide, link_options)
    content_tag(:li, slide_content)
  end  #  def orbit_slideshow_frame(slide, position=0)
  
  def partner_slide(slide, link_options)
		partner_name = slide[:custom_route].gsub("amx-partners-featured-","")
		slide_link = "/partners/featured/#{partner_name}"
    slide_innards = image_tag(slide[:image_url], lazy: false)
    slide_content = link_to(slide_innards, slide_link, link_options)
    slide_content
  end  #  def partner_slide(slide, link_options)
  
end #  module ManufacturerPartnersHelper