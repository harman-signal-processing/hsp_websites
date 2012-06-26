class AddHiddenFlagToProductAttachments < ActiveRecord::Migration
  def self.up
    add_column :product_attachments, :hide_from_product_page, :boolean
  end

  def self.down
    remove_column :product_attachments, :hide_from_product_page
  end
end
