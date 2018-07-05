class AddRegionalSupportToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :send_contact_form_to_regional_support, :boolean, default: false

    Brand.where(name: "Martin").update_all(send_contact_form_to_regional_support: true)
  end
end
