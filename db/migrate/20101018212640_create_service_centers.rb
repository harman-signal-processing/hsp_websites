class CreateServiceCenters < ActiveRecord::Migration
  def self.up
    options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :service_centers, :options => options do |t|
      t.string :name, :limit => 100
      t.string :name2, :limit => 100
      t.string :name3, :limit => 100
      t.string :name4, :limit => 100
      t.string :address, :limit => 100
      t.string :city, :limit => 100
      t.string :state, :limit => 50
      t.string :zip, :limit => 40
      t.string :telephone, :limit => 40
      t.string :fax, :limit => 40
      t.string :email, :limit => 100
      t.string :account_number, :limit => 50
      t.string :website, :limit => 100
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :service_centers
  end
end
