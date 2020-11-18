xml.instruct! :xml, version: "1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  for page in @pages do
    xml.tag! 'url' do
      xml.tag! 'loc', page[:url]
      xml.tag! 'lastmod', page[:updated_at].strftime("%Y-%m-%d")
      xml.tag! 'changefreq', page[:changefreq]
      xml.tag! 'priority', page[:priority]
    end
  end
end
