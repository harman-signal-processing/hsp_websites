class AddDimensionToSwf < ActiveRecord::Migration
  def self.up
    add_column :product_attachments, :width, :integer, :limit => 6
    add_column :product_attachments, :height, :integer, :limit => 6
  end

  def self.down
    remove_column :product_attachments, :width
    remove_column :product_attachments, :height
  end
end
