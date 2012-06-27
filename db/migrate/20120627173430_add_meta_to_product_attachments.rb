class AddMetaToProductAttachments < ActiveRecord::Migration
  def change
    add_column :product_attachments, :product_attachment_meta, :text
  end
end
