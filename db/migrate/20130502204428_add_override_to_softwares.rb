class AddOverrideToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :active_without_products, :boolean
  end
end
