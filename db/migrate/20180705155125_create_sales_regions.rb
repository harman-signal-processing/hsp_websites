class CreateSalesRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_regions do |t|
      t.string :name
      t.integer :brand_id
      t.string :support_email

      t.timestamps
    end
    add_index :sales_regions, :brand_id
  end
end
