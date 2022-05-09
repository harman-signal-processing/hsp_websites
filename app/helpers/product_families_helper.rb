module ProductFamiliesHelper

  def links_to_related_product_families(product_family)

    product_family.siblings_with_current_products.map do |sibling|
      link_to(translate_content(sibling, :name), sibling)
    end.join(", ").html_safe

  end

  def feature_page_location(feature)
    location = []
    location << "Banner slide" if feature.use_as_banner_slide
    location << "Under products" if feature.show_below_products
    location << "Under videos" if feature.show_below_videos
    location << "default location" if location.empty?
    location.join(",")
  end

  def get_custom_feature_list(features, location_where_feature_to_be_used)
    if location_where_feature_to_be_used == "default"
      features.where(use_as_banner_slide: 0, show_below_products: 0, show_below_videos: 0)
    else
      features.where("#{location_where_feature_to_be_used}": 1)
    end
  end  #  def get_custom_feature_list(location_where_feature_to_be_used)

end  #  module ProductFamiliesHelper
