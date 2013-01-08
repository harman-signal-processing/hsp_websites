class CreatePricingTypes < ActiveRecord::Migration
  def change
    create_table :pricing_types do |t|
      t.string :name
      t.integer :brand_id
      t.integer :pricelist_order
      t.string :calculation_method

      t.timestamps
    end
    add_index :pricing_types, :brand_id
  end
end
