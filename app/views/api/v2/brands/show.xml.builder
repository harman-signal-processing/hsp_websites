xml.instruct! :xml, version: "1.0"

xml.brand name: @brand.name do
    if @brand.logo_file_name.present?
        if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
            xml.logo url: @brand.logo.url(:original, timestamp: false)
        else
            xml.logo url: "http://#{request.host}#{@brand.logo.url(:original, timestamp: false)}"
        end 
    end
    if @brand.news_feed_url.present?
	   xml.rss url: @brand.news_feed_url
    end
    if @brand.default_website
	   xml.website url: "http://#{@brand.default_website.url}"
    end
    xml.tag! "current_products" do 
        @brand.current_products.each do |product|
            xml.product(product.name, 
                name: product.name,
                url: api_v2_product_url(product, format: :xml).gsub!(/\?.*$/, '')
            )
        end
    end 
end
