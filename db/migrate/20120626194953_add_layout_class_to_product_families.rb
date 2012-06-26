class AddLayoutClassToProductFamilies < ActiveRecord::Migration
  def change
    add_column :product_families, :layout_class, :string
  end
end
