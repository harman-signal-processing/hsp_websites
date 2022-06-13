class DropTableToneLibrarySongs < ActiveRecord::Migration[6.1]
  def change
    drop_table :tone_library_songs
    drop_table :tone_library_patches
    remove_column :brands, :has_tone_library
  end
end
