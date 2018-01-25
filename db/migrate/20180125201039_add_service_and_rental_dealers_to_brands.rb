class AddServiceAndRentalDealersToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :dealers_include_rental_and_service, :boolean, default: false

    Brand.find("martin").update_column(:dealers_include_rental_and_service, true)
  end
end
