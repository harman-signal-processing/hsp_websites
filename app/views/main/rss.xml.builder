xml.instruct! :xml, version: "1.0" 
xml.rss(version: "2.0"){
  xml.channel{
    xml.title(@title)
    xml.link root_url(only_path: false)
    xml.description(@description)
    xml.language("#{website.folder}/#{I18n.locale}")
      for news in @news
        xml.item do
          xml.title(translate_content(news, :title))
          xml.description(translate_content(news, :body))      
          # xml.author(news.author_name)               
          xml.pubDate(news.post_on.to_time.advance(hours: 9).strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link news_url(news, only_path: false)
          xml.guid news_url(news, only_path: false)
        end
      end
  }
}