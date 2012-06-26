class CreateToneLibrarySongs < ActiveRecord::Migration
  def self.up
    create_table :tone_library_songs do |t|
      t.string :artist_name
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :tone_library_songs
  end
end
