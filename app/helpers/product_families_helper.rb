module ProductFamiliesHelper

  # Take into account families with one product. If so, avoid a redirect
  # by linking directly to the one product.
  def best_product_family_url(product_family)
    if product_family.features.length == 0 && product_family.current_products_plus_child_products(website).length == 1
      product_family.current_products_plus_child_products(website).first
    else
      product_family
    end
  end

  def links_to_related_product_families(product_family)

    product_family.siblings_with_current_products.map do |sibling|
      link_to(translate_content(sibling, :name), sibling)
    end.join(", ").html_safe

  end

end  #  module ProductFamiliesHelper
