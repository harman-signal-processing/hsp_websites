class CreateCabinets < ActiveRecord::Migration
  def self.up
    create_table :cabinets do |t|
      t.string :name
      t.text :description
      t.string :cab_image_file_name
      t.integer :cab_image_file_size
      t.string :cab_image_content_type
      t.datetime :cab_image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :cabinets
  end
end
