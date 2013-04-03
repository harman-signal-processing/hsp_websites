class AddBrandNameIndex < ActiveRecord::Migration
  def up
    add_index :brands, :name, :unique => true
  end

  def down
    drop_index :brands, :name
  end
end
