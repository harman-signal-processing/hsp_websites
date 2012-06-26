class CreateLocaleProductFamilies < ActiveRecord::Migration
  def self.up
    create_table :locale_product_families do |t|
      t.string :locale
      t.integer :product_family_id

      t.timestamps
    end
  end

  def self.down
    drop_table :locale_product_families
  end
end
