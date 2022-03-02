class CreateCustomizableAttributeValues < ActiveRecord::Migration[6.1]
  def change
    create_table :customizable_attribute_values do |t|
      t.integer :customizable_attribute_id
      t.integer :product_id
      t.string :value

      t.timestamps
    end
  end
end
