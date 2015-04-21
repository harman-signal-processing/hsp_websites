module VideosHelper

  def related_product_links_for_video(video)
    products = []
    if video['tags'] && video['tags'].is_a?(Array)
      video['tags'].each do |tag|
        begin
          if p = Product.find(tag.downcase.gsub(/\s/, "-"))
            products << link_to(p.name, p) if p.show_on_website?(website)
          end
        rescue
          # logger.debug "Record not found for #{tag.downcase.gsub(/\s/, '-')}"
        end
      end
    end
    if products.size > 0
      raw("<p><b>Related Products:</b> #{products.join(', ')}</p>")
    else
      ""
    end
  end

end
