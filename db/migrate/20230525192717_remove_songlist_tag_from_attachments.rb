class RemoveSonglistTagFromAttachments < ActiveRecord::Migration[7.0]
  def change
    remove_column :product_attachments, :songlist_tag, :string
  end
end
