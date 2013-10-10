class RenameNewsPhotoUpdatedAt < ActiveRecord::Migration
  def up
  	rename_column :news, :news_photo_created_at, :news_photo_updated_at
  end

  def down
  	rename_column :news, :news_photo_updated_at, :news_photo_created_at
  end
end
