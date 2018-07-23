class AddPositionToProductSiteElements < ActiveRecord::Migration[5.1]
  def change
    add_column :product_site_elements, :position, :integer
  end
end
