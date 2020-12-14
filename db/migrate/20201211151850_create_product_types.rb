class CreateProductTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :product_types do |t|
      t.string :name
      t.boolean :default, default: false
      t.boolean :digital_ecom, default: false

      t.timestamps
    end


    standard = ProductType.create!(
      name: "Standard",
      default: true,
      digital_ecom: false
    )

    add_column :products, :product_type_id, :integer
    Product.update_all(product_type_id: standard.id)

    ProductType.create!(
      name: "Ecommerce-Digital Download",
      default: false,
      digital_ecom: true
    )
  end
end
