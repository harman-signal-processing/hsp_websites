module ProductFamiliesHelper
  
  def links_to_related_product_families(product_family)
    links = []
    product_family.siblings_with_current_products.each do |sibling|
      links << link_to(translate_content(sibling, :name), sibling)
    end
    raw(links.join(", "))
  end
  
end
