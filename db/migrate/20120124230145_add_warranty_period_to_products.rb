class AddWarrantyPeriodToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :warranty_period, :integer
    Brand.find_by_name("dbx").products.each do |product|
      product.update_attributes(:warranty_period => 2)
    end
  end

  def self.down
    remove_column :products, :warranty_period
  end
end
