class AddPhotometricsToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :has_photometrics, :boolean
  end
end
