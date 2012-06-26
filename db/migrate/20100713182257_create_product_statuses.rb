class CreateProductStatuses < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_statuses, :options => options do |t|
      t.string :name
      t.boolean :show_on_website, :default => false
      t.boolean :discontinued, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :product_statuses
  end
end
