class CreateProductFamilyProductFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :product_family_product_filters do |t|
      t.integer :product_family_id
      t.integer :product_filter_id
      t.integer :position

      t.timestamps
    end
    add_index :product_family_product_filters, :product_family_id
    add_index :product_family_product_filters, :product_filter_id
  end
end
