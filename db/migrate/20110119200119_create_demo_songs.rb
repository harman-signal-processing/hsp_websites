class CreateDemoSongs < ActiveRecord::Migration
  def self.up
    create_table :demo_songs do |t|
      t.integer :product_attachment_id
      t.integer :position
      t.string :title
      t.string :mp3_file_name
      t.integer :mp3_file_size
      t.string :mp3_content_type
      t.datetime :mp3_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :demo_songs
  end
end
