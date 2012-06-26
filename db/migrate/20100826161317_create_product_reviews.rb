class CreateProductReviews < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_reviews, :options => options do |t|
      t.string :title
      t.string :external_link
      t.text :body
      t.string :review_file_name
      t.integer :review_file_size
      t.string :review_content_type
      t.datetime :review_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_reviews
  end
end
