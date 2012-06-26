class CreateSpecifications < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :specifications, :options => options do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :specifications
  end
end
