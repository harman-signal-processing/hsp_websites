class DropRegions < ActiveRecord::Migration
  def change
    drop_table :regions
    remove_column :training_classes, :region_id
  end
end
