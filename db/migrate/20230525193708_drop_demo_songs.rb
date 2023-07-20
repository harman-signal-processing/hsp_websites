class DropDemoSongs < ActiveRecord::Migration[7.0]
  def change
    drop_table :demo_songs
  end
end
