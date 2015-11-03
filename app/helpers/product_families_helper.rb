module ProductFamiliesHelper

  def links_to_related_product_families(product_family)

    product_family.siblings_with_current_products.map do |sibling|
      link_to(translate_content(sibling, :name), sibling)
    end.join(", ").html_safe

  end

end
