class AddLinkToSoftware < ActiveRecord::Migration
  def self.up
    add_column :softwares, :link, :string
  end

  def self.down
    remove_column :softwares, :link
  end
end