class AddRentalFlagToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :offers_rentals, :boolean
    ["crown", "dbx", "bss"].each do |b|
      brand = Brand.find(b)
      brand.update_column(:offers_rentals, true)
    end
  end
end
