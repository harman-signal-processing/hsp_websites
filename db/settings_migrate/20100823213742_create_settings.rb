class CreateSettings < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :settings, :options => options do |t|
      t.string :name
      t.string :setting_type
      t.string :string_value
      t.integer :integer_value
      t.text :text_value
      t.string :slide_file_name
      t.integer :slide_file_size
      t.string :slide_content_type
      t.datetime :slide_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
