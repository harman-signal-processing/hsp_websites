class AddGlobalDealersToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :dealers_are_us_only, :boolean, default: true

    Brand.update_all(dealers_are_us_only: true)
    Brand.find("martin").update_column(:dealers_are_us_only, false)
  end
end
