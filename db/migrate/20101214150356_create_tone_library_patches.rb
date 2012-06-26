class CreateToneLibraryPatches < ActiveRecord::Migration
  def self.up
    create_table :tone_library_patches do |t|
      t.integer :tone_library_song_id
      t.integer :product_id
      t.string :patch_file_name
      t.integer :patch_file_size
      t.datetime :patch_updated_at
      t.string :patch_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :tone_library_patches
  end
end
