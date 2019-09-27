class RenameHideFromNavigationOnProductFamilies < ActiveRecord::Migration[5.2]
  def change
    rename_column :product_families, :hide_from_homepage, :hide_from_navigation

    begin
      crown = Brand.find "crown"
      ProductFamily.where(hide_from_navigation: true).where.not(brand: crown).update_all(hide_from_navigation: false)
    rescue
      puts "Will need to manually check any families that used to be marked as 'hide from homepage'."
    end
  end
end
