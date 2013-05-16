class AddMediaUsers < ActiveRecord::Migration
  def up
  	add_column :users, :media, :boolean
  	add_column :toolkit_resources, :media, :boolean, default: true

  	ToolkitResource.update_all(media: true)
  end

  def down
  	remove_column :users, :media 
  	remove_column :toolkit_resources, :media
  end
end
