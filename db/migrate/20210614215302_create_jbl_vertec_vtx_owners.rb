class CreateJblVertecVtxOwners < ActiveRecord::Migration[6.1]
  def change
    create_table :jbl_vertec_vtx_owners do |t|
      t.string :company_name, :limit => 100
      t.string :address, :limit => 100
      t.string :city, :limit => 100
      t.string :state, :limit => 50
      t.string :postal_code, :limit => 40
      t.string :country, :limit => 100
      t.string :phone, :limit => 100
      t.string :email, :limit => 100
      t.string :website, :limit => 100
      t.string :contact_name, :limit => 100
      t.string :rental_products
      t.text :comment
      t.boolean :approved, :default => false
      t.string :approved_by
      t.integer :dealer_id
      t.timestamps
    end
  end
end
