class AddWarrantyPeriodToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :warranty_period, :integer
  end
end
