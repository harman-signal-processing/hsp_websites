class ResetAllProductFamilyLocaleCacheCounters < ActiveRecord::Migration[6.1]
  def up
    ProductFamily.all.each do |product_family|
      ProductFamily.reset_counters(product_family.id, :locale_product_families)
    end
  end

  def down
  end
end
