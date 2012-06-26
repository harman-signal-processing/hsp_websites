class CreateClinicProducts < ActiveRecord::Migration
  def self.up
    create_table :clinic_products do |t|
      t.integer :clinic_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clinic_products
  end
end
