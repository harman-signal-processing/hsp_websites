class CreateSoftwares < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :softwares, :options => options do |t|
      t.string :name
      t.string :ware_file_name
      t.integer :ware_file_size
      t.string :ware_content_type
      t.datetime :ware_updated_at
      t.integer :download_count
      t.string :version
      t.text :description
      t.string :platform
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :softwares
  end
end
