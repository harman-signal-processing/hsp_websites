class CreateProductAttachments < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_attachments, :options => options do |t|
      t.integer :product_id
      t.boolean :primary_photo, :default => false
      t.string :product_attachment_file_name
      t.string :product_attachment_content_type
      t.datetime :product_attachment_updated_at
      t.integer :product_attachment_file_size
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :product_attachments
  end
end
