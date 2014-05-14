module NewsHelper

  # Using zurb foundation to show the product images
  #
  def interchange_news_thumbnail(news)
    q = []

    q << "[#{news.news_photo.url(:email)}, (default)]"
    q << "[#{news.news_photo.url(:large)}, (only screen and (min-width: 769px))]"
    q << "[#{news.news_photo.url(:medium)}, (only screen and (max-width: 768px))]"

    image_tag(news.news_photo.url(:email),
      data: { interchange: q.join(", ") })
  end

end