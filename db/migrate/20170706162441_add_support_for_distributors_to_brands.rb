class AddSupportForDistributorsToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :send_contact_form_to_distributors, :boolean
  end
end
