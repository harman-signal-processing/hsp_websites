module FeaturesHelper

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
    if feature.image.present? || feature.content.present?
      position_class = "medium-6 small-12 columns end"
      position_class += " medium-offset-6 " if feature.content_position.to_s == "right"

      content_class = { class: "wide-feature container" }
      img = ""
      if feature.image.present?
        if opt[:format].present? && opt[:format] == "mobile"
          img = feature.image.url(:medium)
        else
          img = feature.image.url(:extra_large)
        end
        content_class[:style] = "background-image: url(#{img});"
      end

      if opt[:format].present? && opt[:format] == "mobile"
        content_tag :div, class: "wide-feature"  do
          image_tag(img, alt: "featured content") + render_feature_text(feature, opt)
        end
      else
        content_tag :div, content_class  do
          content_tag :div, class: "row" do
            content_tag :div, class: position_class do
              render_feature_text(feature, opt)
            end
          end
        end
      end
    end
  end

  # Renders wide feature with text underneath
  def render_wide2_feature(feature, opt={})
    if feature.image.present? || feature.content.present?
      img = ""
      if feature.image.present?
        if opt[:format].present? && opt[:format] == "mobile"
          img = feature.image.url(:medium)
        else
          img = feature.image.url(:original)
        end
      end

      content_tag :div, class: "wide2-feature"  do
        image_tag(img, alt: "featured content") + content_tag(:br) +
        raw(update_youtube_links(translate_content(feature, :content))) +
        content_tag(:br)
      end
    end
  end

  # Renders split-panel features with text on one side
  def render_split_feature(feature, opt={})
    small_image_panel = content_tag :div,
      class: "hide-for-medium-up show-for-small small-12 columns" do
      image_tag feature.image.url(:large)
    end
    image_panel = content_tag :div, raw('&nbsp;'),
      class: "medium-7 hide-for-small columns image-container",
      style: "background-image: url(#{feature.image.url});",
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
    if feature.content.present?
      content_tag :div, class: "borderless feature-text panel", data: data do
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
end
