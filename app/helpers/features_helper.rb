module FeaturesHelper

  # Selects which type of feature to render
  def render_feature(feature)
    render_pre_content(feature) + case feature.layout_style
    when "wide"
      render_wide_feature(feature)
    when "split"
      render_split_feature(feature)
    else
      render_feature_text(feature)
    end
  end # def render_feature

  # Renders wide feature with text overlay
  def render_wide_feature(feature)
    position_class = "medium-6 small-11 columns end"
    position_class += " medium-offset-6 small-offset-1 " if feature.content_position.to_s == "right"

    content_tag :div, class: "wide-feature container", style: "background-image: url(#{feature.image.url(:extra_large)});" do
      content_tag :div, class: "row" do
        content_tag :div, class: position_class do
          render_feature_text(feature)
        end
      end
    end
  end # def render_wide_feature

  # Renders split-panel features with text on one side
  def render_split_feature(feature)
    small_image_panel = content_tag :div,
      class: "hide-for-medium-up show-for-small small-12 columns" do
      image_tag feature.image.url(:large)
    end
    image_panel = content_tag :div, raw('&nbsp;'),
      class: "medium-7 hide-for-small columns image-container",
      style: "background-image: url(#{feature.image.url});"
    text_panel = content_tag :div, class: "medium-5 small-12 columns" do
      render_feature_text(feature)
    end
    content_tag :div, class: "row collapse split-feature" do
      if feature.content_position.to_s == "right"
        small_image_panel + image_panel + text_panel
      else
        small_image_panel + text_panel + image_panel
      end
    end
  end # def render_split_feature

  # Renders just the text of a feature
  def render_feature_text(feature)
    content_tag :div, class: "borderless feature-text panel" do
      raw(update_youtube_links(feature.content))
    end
  end # def render_feature_text

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
  end # def update_youtube_links

  def render_pre_content(feature)
    content_tag :div do
      raw(feature.pre_content)
    end
  end
end
