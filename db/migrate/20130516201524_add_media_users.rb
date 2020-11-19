class AddMediaUsers < ActiveRecord::Migration
  def up
  	add_column :users, :media, :boolean
  end

  def down
  	remove_column :users, :media
  end
end
