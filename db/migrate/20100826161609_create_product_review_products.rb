class CreateProductReviewProducts < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_review_products, :options => options do |t|
      t.integer :product_id
      t.integer :product_review_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_review_products
  end
end
