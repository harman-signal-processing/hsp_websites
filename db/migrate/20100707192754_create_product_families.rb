class CreateProductFamilies < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_families, :options => options do |t|
      t.string :name
      t.string :family_photo_file_name
      t.string :family_photo_content_type
      t.datetime :family_photo_updated_at
      t.integer :family_photo_file_size
      t.text :intro
      t.integer :brand_id
      t.text :keywords
      t.integer :position
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :product_families
  end
end
