class AddWarrantyPeriodToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :warranty_period, :integer
    Brand.where(name: "dbx").first.products.each do |product|
      product.update(:warranty_period => 2)
    end
  end

  def self.down
    remove_column :products, :warranty_period
  end
end
