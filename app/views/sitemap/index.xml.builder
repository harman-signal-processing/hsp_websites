xml.instruct! :xml, version: "1.0"
xml.tag! 'sitemapindex', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  for page in @pages do
    xml.tag! 'sitemap' do
      xml.tag! 'loc', page[:url]
      xml.tag! 'lastmod', page[:updated_at].strftime("%Y-%m-%d")
    end
  end
end
