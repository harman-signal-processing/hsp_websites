class CurrentProductCount < ApplicationRecord
  belongs_to :product_family

  before_save :update_count

  def update_count
    self.current_products_plus_child_products_count = current_products_plus_child_products(product_family).size
    if self.current_products_plus_child_products_count_changed?
      brand_website.add_log(user: User.system,
        action: "Updated product count for #{self.product_family.name} (#{self.product_family.to_param}), locale: #{self.locale}, old count: #{self.current_products_plus_child_products_count_was}, new count: #{self.current_products_plus_child_products_count}"
      )
    end
  end

  private

  # Do this here so we can use our stored locale
  # Also, loop through all children so the list can be unique'd before counting
  def current_products_plus_child_products(family)
    cp = []
    I18n.locale = self.locale
    family.current_products.each do |prod|
      if prod.locales(brand_website).include?(self.locale)
        cp << prod
      end
    end
    family.children_with_current_products(brand_website, locale: self.locale).each do |pf|
      cp += current_products_plus_child_products(pf)
    end
    cp.uniq
  end

  def brand_website
    @brand_website ||= product_family.brand.default_website
  end

end
