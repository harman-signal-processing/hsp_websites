class AddGroupOnCustomShopToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :group_on_custom_shop, :boolean, default: false
  end
end
