class AddPanelIdToRsoNavigations < ActiveRecord::Migration
  def self.up
    add_column :rso_navigations, :rso_panel_id, :integer
  end

  def self.down
    remove_column :rso_navigations, :rso_panel_id
  end
end
