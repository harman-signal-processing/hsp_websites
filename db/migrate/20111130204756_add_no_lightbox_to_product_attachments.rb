class AddNoLightboxToProductAttachments < ActiveRecord::Migration
  def self.up
    add_column :product_attachments, :no_lightbox, :boolean
  end

  def self.down
    remove_column :product_attachments, :no_lightbox
  end
end
