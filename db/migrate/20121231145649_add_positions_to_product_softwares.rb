class AddPositionsToProductSoftwares < ActiveRecord::Migration
  def change
    add_column :product_softwares, :product_position, :integer
    add_column :product_softwares, :software_position, :integer
  end
end
