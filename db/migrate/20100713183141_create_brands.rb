class CreateBrands < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :brands, :options => options do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
