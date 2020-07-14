class AddShippingStatus < ActiveRecord::Migration
  def self.up
    add_column :product_statuses, :shipping, :boolean, :default => false
    ProductStatus.where(name: "In Production").first.update(:shipping => true)
  end

  def self.down
    remove_column :product_statuses, :shipping
  end
end
