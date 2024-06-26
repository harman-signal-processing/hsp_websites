module MainHelper

  # Borrowed from rails 3.2 source so I can avoid rewriting all of
  # the link_to_function calls in my code
  def link_to_function(name, function, html_options={})
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def feature_button(feature, opts={})
    if feature.name.present?
      panel = image_tag(feature.slide.url, alt: feature.name, lazy: false)
    else
      panel = image_tag(feature.slide.url, lazy: false)
    end

    if opts[:carousel] == true
      panel += content_tag(:h6, feature.name)
      panel += content_tag(:p, feature.text_value, style: 'color: black')
      panel += content_tag(:p, 'LEARN MORE')
    end

    if feature.string_value.blank?
      panel
    else
      if feature.string_value =~ /^https?\:/i
        link_to(panel, feature.string_value, target: "_blank")
      elsif feature.string_value =~ /^\//
        link_to(panel, feature.string_value)
      else
        link_to(panel, "/#{params[:locale]}/#{feature.string_value}")
      end
    end
  end

  def youtube_feed(youtube_user)
    if youtube_user
      play_button = content_tag(:div, "", class: "videoplay")
      vids = []

      begin
        Youtube.new(youtube_user).get_videos(limit: 4).each do |video|
          vids << content_tag(:li, class: 'video-thumbnail') do
            link_to(image_tag(video[:thumbnail], alt: 'play video', width: 320, height: 180) + play_button, play_video_url(video[:id]), target: "_blank",
                    data: { videoid: video[:id] }, class: 'videothumbnail start-video') +
            content_tag(:p, video[:title], class: 'video_title')
          end
        end
        content_tag(:ul, raw(vids.join), id: 'video_list', class: "large-block-grid-4 medium-block-grid-4 small-block-grid-2")
      rescue
        if !youtube_user.blank?
          link_to("YouTube Channel", "https://www.youtube.com/user/#{youtube_user}", target: "_blank")
        end
      end
    end
  end

  def preload_background_images
    begin
      content = ""
      website.products.where("background_image_file_name IS NOT NULL").each do |product|
        content += image_tag(product.background_image.url("original", false), alt: product.name, height: 0, width: 0, lazy: false)
  	  end
  	  content.html_safe
	  rescue
	    ""
    end
  end

  def product_family_nav_links(product_family, options={})
    if product_family.locales(website).include?(I18n.locale.to_s)
      default_options = {depth: 99}
      options = default_options.merge options

      child_links = []
      product_links = []

      if options[:depth] > 1
        relevant_children = product_family.children_with_current_products(website, locale: I18n.locale)
        child_links = relevant_children.map do |sub_family|
          product_family_nav_links(sub_family, options)
        end
        options[:depth] -= 1

        if options[:depth] > 1
          product_links = product_family.current_products.map do |product|
            content_tag(:li, link_to(translate_content(product, :name), product))
          end
        end
      end

      dropdown_class = (child_links + product_links).length > 0 ? "has-dropdown" : ""

      nav_html =
        content_tag(:li, class: dropdown_class) do
          link_to(translate_content(product_family, :name), product_family) +
          content_tag(:ul, child_links.join.html_safe + product_links.join.html_safe, class: "dropdown")
        end.html_safe

      # This is a custom solution (for AMX) to combine some parent and child links in the nav list
      if website.value_for("family-slugs-to-be-collapsed-in-nav").present? && website.value_for("family-slugs-to-be-collapsed-in-nav").gsub(/\s+/, "") .split(",").include?(product_family.cached_slug)
        nav_html = child_links.join.html_safe
      end

      # This is also a custom solution (for AMX) to use a nav separator for some nav items
      if product_family.product_nav_separator.present?
        nav_separator_html = content_tag(:li, link_to(product_family.product_nav_separator, "#"))
        nav_separator_html + nav_html
      else
        nav_html
      end

    end  #  if product_family.locales(website).include?(I18n.locale.to_s)
  end  #  def product_family_nav_links(product_family, options={})

  def market_segment_nav_links(market_segment, options={})
    default_options = {depth: 99}
    options = default_options.merge options

    child_links = []

    relevant_children = market_segment.children
    options[:depth] += 1 if relevant_children.length > 0

    if options[:depth] > 1
      child_links = relevant_children.map do |sub_family|
        market_segment_nav_links(sub_family, options)
      end
      options[:depth] -= 1
    end

    dropdown_class = child_links.length > 0 ? "has-dropdown" : ""

    content_tag(:li, class: dropdown_class) do
      link_to(translate_content(market_segment, :name), market_segment) +
      content_tag(:ul, child_links.join.html_safe, class: "dropdown")
    end.html_safe
  end

  def flag_for(item)
    if item.respond_to?(:language) && item.language.present?
      if File.exist?(Rails.root.join("app", "assets", "images", "icons", "flags", "#{item.language.to_s.downcase}.png"))
        image_tag("icons/flags/#{item.language.to_s.downcase}.png", alt: item.language, lazy: false)
      else
        ""
      end
    end
  end
end

