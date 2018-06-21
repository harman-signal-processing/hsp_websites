class CreateProductBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :product_badges do |t|
      t.integer :badge_id
      t.integer :product_id

      t.timestamps
    end
    add_index :product_badges, :badge_id
    add_index :product_badges, :product_id
  end
end
