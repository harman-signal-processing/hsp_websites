module NewsHelper

  # Determine the best news URL. Takes into consideration if the article
  # doesn't really belong to this brand, but had products that do. If so,
  # link to the other brand's domain.
  def best_news_url(news)
    if website.news.include?(news)
      news
    else
      brand = website.brand # default which should get replaced:
      if news.products.size > 0
        brand = news.products.first.brand
      elsif news.brands.size > 0
        brand = news.brands.first
      end
      news_url(news, host: brand.default_website.url)
    end
  end

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

  def quote_or_headline(news)
    src = news.quote.present? ? :quote : :title
    translate_content(news, src)
  end

  def homepage_news_header
    if website.homepage_news_header
      website.homepage_news_header
    else
      "The Latest From #{ website.brand.name }"
    end
  end

end
