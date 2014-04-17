module NewsHelper

  # Using zurb foundation to show the product images
  #
  def interchange_news_thumbnail(news)
    q = []

    q << "[#{news.news_photo.url(:thumb_square)}, (default)]"
    q << "[#{news.news_photo.url(:medium)}, (only screen and (max-width: 768px))]"

    image_tag(news.news_photo.url(:thumb_square),
      data: { interchange: q.join(", ") })
  end

end