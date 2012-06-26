class AddMediaToProductAttachments < ActiveRecord::Migration
  def self.up
    add_column :product_attachments, :product_media_file_name, :string
    add_column :product_attachments, :product_media_content_type, :string
    add_column :product_attachments, :product_media_file_size, :integer
    add_column :product_attachments, :product_media_updated_at, :datetime
    
    add_column :product_attachments, :product_media_thumb_file_name, :string
    add_column :product_attachments, :product_media_thumb_content_type, :string
    add_column :product_attachments, :product_media_thumb_file_size, :integer
    add_column :product_attachments, :product_media_thumb_updated_at, :datetime
  end

  def self.down
    remove_column :product_attachments, :product_media_file_name
    remove_column :product_attachments, :product_media_content_type
    remove_column :product_attachments, :product_media_file_size
    remove_column :product_attachments, :product_media_updated_at
    
    remove_column :product_attachments, :product_media_thumb_file_name
    remove_column :product_attachments, :product_media_thumb_content_type
    remove_column :product_attachments, :product_media_thumb_file_size
    remove_column :product_attachments, :product_media_thumb_updated_at
  end
end
