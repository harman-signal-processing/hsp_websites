class AddProductSelectorBehaviorToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :product_selector_behavior, :string
  end
end
