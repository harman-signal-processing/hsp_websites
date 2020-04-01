class AddSecondaryUomToProductFilters < ActiveRecord::Migration[5.2]
  def change
    add_column :product_filters, :secondary_uom, :string
    add_column :product_filters, :secondary_uom_formula, :string
    add_column :product_filters, :stepsize, :integer, default: 1
  end
end
