class AddUrlToRsoPanels < ActiveRecord::Migration
  def self.up
    add_column :rso_panels, :url, :string
  end

  def self.down
    remove_column :rso_panels, :url
  end
end
