class AddHasInstallationsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_installations, :boolean
  end
end
