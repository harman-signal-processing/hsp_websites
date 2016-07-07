class AddProductRegistrationsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_product_registrations, :boolean, default: true
  end
end
