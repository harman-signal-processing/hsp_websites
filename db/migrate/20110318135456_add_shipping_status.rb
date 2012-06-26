class AddShippingStatus < ActiveRecord::Migration
  def self.up
    add_column :product_statuses, :shipping, :boolean, :default => false
    ProductStatus.find_by_name("In Production").update_attributes(:shipping => true)
  end

  def self.down
    remove_column :product_statuses, :shipping
  end
end