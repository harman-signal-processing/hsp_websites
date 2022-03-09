class CreateProductInnovations < ActiveRecord::Migration[6.1]
  def change
    create_table :product_innovations do |t|
      t.integer :product_id
      t.integer :innovation_id

      t.timestamps
    end
    add_index :product_innovations, :product_id
    add_index :product_innovations, :innovation_id
  end
end
