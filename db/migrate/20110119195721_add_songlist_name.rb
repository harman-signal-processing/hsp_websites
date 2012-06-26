class AddSonglistName < ActiveRecord::Migration
  def self.up
    add_column :product_attachments, :songlist_tag, :string
  end

  def self.down
    remove_column :product_attachments, :songlist_tag
  end
end