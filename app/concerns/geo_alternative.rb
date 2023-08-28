# Models can include this module to enable geo-redirection to other instances
# when the current instance isn't intended for the current locale. To make it work,
# the model should have a "geo_parent_id" attribute. The "parent" is the main
# instance that is intended for most locales where any "child" alternatives
# are intended for other locale(s)
module GeoAlternative
  extend ActiveSupport::Concern

  included do
    belongs_to :geo_parent,
      class_name: name,
      optional: true

    has_many :geo_children,
      class_name: name,
      foreign_key: 'geo_parent_id'
  end

  def geo_alternative_locales(website)
    geo_children.map{|c| c.locales(website) }.flatten.uniq
  end

  def geo_alternative(website, target_locale)
    # If this is a parent item, search its children for a matching locale
    geo_children.each do |item|
      return item if item.locales(website).include?(target_locale.to_s)
    end

    # If this is a child item, see if its parent includes the locale
    if geo_parent
      return geo_parent if geo_parent.locales(website).include?(target_locale.to_s)

      # Finally, search siblings by trying the same method on the parent
      return geo_parent.geo_alternative(website, target_locale)
    end

    # Otherwise, no alternative record is found
    return false
  end

end
