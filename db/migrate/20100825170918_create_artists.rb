class CreateArtists < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :artists, :options => options do |t|
      t.string :name
      t.text :bio
      t.string :artist_photo_file_name
      t.string :artist_photo_content_type
      t.datetime :artist_photo_updated_at
      t.integer :artist_photo_file_size
      t.string :website
      t.string :twitter
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
