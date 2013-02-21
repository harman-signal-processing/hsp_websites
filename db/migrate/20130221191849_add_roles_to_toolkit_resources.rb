class AddRolesToToolkitResources < ActiveRecord::Migration
  def change
    add_column :toolkit_resources, :dealer, :boolean, default: true
    add_column :toolkit_resources, :distributor, :boolean, default: true
    add_column :toolkit_resources, :rep, :boolean, default: true
    add_column :toolkit_resources, :rso, :boolean, default: true
  end
end
