module FeaturesHelper

  def feature_page_location(feature)
    location = []
    location << "Banner slide" if feature.use_as_banner_slide
    location << "Under products" if feature.show_below_products
    location << "Under videos" if feature.show_below_videos
    location << "default location" if location.empty?
    location.join(",")
  end

  def get_custom_feature_list(features, location_where_feature_to_be_used='default')
    if location_where_feature_to_be_used == "default"
      features.where(use_as_banner_slide: 0, show_below_products: 0, show_below_videos: 0)
    else
      features.where("#{location_where_feature_to_be_used}": 1)
    end
  end

  # Selects which type of feature to render
  def render_feature(feature, opt={})
    render_pre_content(feature) + render_styled_feature(feature, opt)
  end

  def render_styled_feature(feature, opt)
    if feature.layout_style.present?
      send("render_#{ feature.layout_style }_feature", feature, opt)
    else
      render_feature_text(feature, opt)
    end
  end

  # Renders wide feature with text overlay
  def render_wide_feature(feature, opt={})
    if feature.image.present? || feature.content.present? || feature.video.present?
      position_class = "medium-6 small-12 columns end"
      position_class += " medium-offset-6 " if feature.content_position.to_s == "right"

      content_class = { class: "wide-feature container" }
      media = ""
      if feature.video.present?
        if opt[:format].present? && opt[:format] == "mobile"
          media = content_tag(:div, class: "flex-video") do
            video_tag(feature.video.url,
              autoplay: true,
              muted: true,
              loop: true,
              poster: feature.image.present? ? translate_image_url(feature, :image, size: :medium) : '')
            end
        else
          media = video_tag(feature.video.url,
            autoplay: true,
            muted: true,
            loop: true,
            poster: feature.image.present? ? translate_image_url(feature, :image, size: :extra_large) : '')
          content_class[:class] += " feature-with-video"
        end
      elsif feature.image.present?
        if opt[:format].present? && opt[:format] == "mobile"
          img = translate_image_url(feature, :image, size: :medium)
        else
          img = translate_image_url(feature, :image, size: :extra_large)
          content_class[:style] = "background-image: url(#{img});"
        end
        media = image_tag(img, alt: "featured content")
      end

      if opt[:format].present? && opt[:format] == "mobile"
        content_tag :div, class: "wide-feature"  do
          media + render_feature_text(feature, opt)
        end
      elsif feature.video.present?
        content_tag :div, content_class  do
          media + (content_tag :div, class: "row" do
            content_tag :div, class: position_class do
              render_feature_text(feature, opt)
            end
          end)
        end
      else
        content_tag :div, content_class  do
          (content_tag :div, class: "row" do
            content_tag :div, class: position_class do
              render_feature_text(feature, opt)
            end
          end)
        end
      end
    end
  end

  # Renders wide feature with text underneath
  def render_wide2_feature(feature, opt={})
    if feature.image.present? || feature.content.present? || feature.video.present?
      content_class = { class: "wide2-feature" }
      media = ""
      if feature.video.present?
        media = content_tag(:div, class: "flex-video") do
          video_tag(feature.video.url,
            autoplay: true,
            muted: true,
            loop: true,
            poster: feature.image.present? ? translate_image_url(feature, :image, size: :medium) : '')
          end
      elsif feature.image.present?
        if opt[:format].present? && opt[:format] == "mobile"
          img = translate_image_url(feature, :image, size: :medium)
        else
          img = translate_image_url(feature, :image, size: :original)
        end
        media = image_tag(img, alt: "featured content") + content_tag(:br)
      end

      content_tag :div, content_class  do
        media +
        raw(update_youtube_links(translate_content(feature, :content))) +
        content_tag(:br)
      end
    end
  end

  # Renders split-panel features with text on one side
  def render_split_feature(feature, opt={})
    media = " "
    content_class = { class: "medium-7 hide-for-small columns image-container" }
    if feature.video.present?
      if opt[:format].present? && opt[:format] == "mobile"
        small_media = content_tag(:div, class: "flex-video") do
          video_tag(feature.video.url,
            autoplay: true,
            muted: true,
            loop: true,
            poster: feature.image.present? ? translate_image_url(feature, :image, size: :medium) : '')
          end
      else
        media = video_tag(feature.video.url,
          autoplay: true,
          muted: true,
          loop: true,
          poster: feature.image.present? ? translate_image_url(feature, :image, size: :extra_large) : '')
        content_class[:class] += " feature-with-video"
      end
    elsif feature.image.present?
      small_media = translate_image_tag(feature, :image, size: :large)
      content_class[:style] = "background-image: url(#{feature.image.url});"
    end

    small_image_panel = content_tag :div,
      class: "hide-for-medium-up show-for-small small-12 columns" do
      small_media
    end

    image_panel = content_tag :div, media, content_class,
      data: { 'equalizer-watch': "feature_#{feature.to_param}" }

    text_panel = content_tag :div, render_feature_text(feature, opt),
      class: "medium-5 small-12 columns",
      data: { 'equalizer-watch': "feature_#{feature.to_param}" }

    content_tag :div, class: "row collapse split-feature", data: { equalizer: "feature_#{feature.to_param}" } do
      if feature.content_position.to_s == "right"
        small_image_panel + image_panel + text_panel
      else
        small_image_panel + text_panel + image_panel
      end
    end
  end

  # Renders a feature full of related review quotes if available.
  def render_review_quotes_feature(feature, opt={})
    if feature.featurable_type == "ProductFamily"
      @product_family ||= feature.featurable
      render_partial "product_families/review_quotes"
    elsif feature.featurable_type == "Product"
      @product ||= feature.featurable
      render_partial "products/reviews"
    end
  end

  # Renders just the text of a feature
  def render_feature_text(feature, opt={})
    data = (opt[:format].present? && opt[:format] == "mobile") ? {} :
      { 'equalizer-watch': "feature_#{feature.to_param}" }
    styles = []
    styles += ["height: #{opt[:text_height]}", "overflow: hidden"] if opt[:text_height].present?
    if feature.content.present?
      content_tag :div, class: "borderless feature-text panel", style: styles.join(";"), data: data do
        raw(update_youtube_links(translate_content(feature, :content)))
      end
    end
  end

  # Inserts tags to cause any linked youtube videos to play in a popup
  def update_youtube_links(content)
    html = Nokogiri::HTML(content)
    html.css('a').each do |l|
      if l["href"].to_s.match(/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/i)
        video_id = $5
        l["target"] = "_blank"
        l["class"] ||= ""
        l["class"] += " start-video"
        l["data-videoid"] = video_id
        l["href"] = play_video_url(video_id)
      end
    end
    html
  end

  def render_pre_content(feature)
    content_tag :div, class: "feature-pre" do
      raw(translate_content(feature, :pre_content))
    end
  end

  # Attempt to calculate a uniform text-box height for a set of features
  def calculate_common_text_height_for_features(features)
    longest_chars = features.reorder("LENGTH(content) DESC").first.content.size
    longest_lines = (longest_chars.to_f / 36.0).to_f # figuring 36 chars per line approx.
    line_height = 30.0 # Just a guess here at how tall one line of text is
    pixel_height = (longest_lines * line_height)  + 30 # Add a little buffer
    "#{pixel_height.to_i}px"
  end

end
