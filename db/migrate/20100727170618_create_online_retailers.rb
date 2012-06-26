class CreateOnlineRetailers < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :online_retailers, :options => options do |t|
      t.string :name
      t.string :retailer_logo_file_name
      t.integer :retailer_logo_file_size
      t.string :retailer_logo_file_type
      t.datetime :retailer_logo_updated_at
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :online_retailers
  end
end
