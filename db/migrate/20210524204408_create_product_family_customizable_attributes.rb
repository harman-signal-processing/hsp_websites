class CreateProductFamilyCustomizableAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :product_family_customizable_attributes do |t|
      t.integer :product_family_id
      t.integer :customizable_attribute_id

      t.timestamps
    end
  end
end
