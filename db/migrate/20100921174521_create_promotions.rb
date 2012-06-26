class CreatePromotions < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :promotions, :options => options do |t|
      t.string :name
      t.date :show_start_on
      t.date :show_end_on
      t.date :start_on
      t.date :end_on
      t.text :description
      t.string :promo_form_file_name
      t.integer :promo_form_file_size
      t.datetime :promo_form_updated_at
      t.string :promo_form_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
