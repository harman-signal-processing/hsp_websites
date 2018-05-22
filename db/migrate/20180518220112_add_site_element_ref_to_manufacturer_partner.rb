class AddSiteElementRefToManufacturerPartner < ActiveRecord::Migration[5.1]
  def change
    add_reference :manufacturer_partners, :site_element, foreign_key: true, type: :integer
  end
end
