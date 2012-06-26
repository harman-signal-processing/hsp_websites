class DropTonesAndGenres < ActiveRecord::Migration
  def self.up
    drop_table :tones
    drop_table :tone_user_ratings
    drop_table :genres
  end

  def self.down
    create_table "tone_user_ratings", :force => true do |t|
      t.integer  "tone_id"
      t.integer  "user_id"
      t.float    "user_rating"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "tones", :force => true do |t|
      t.string   "name"
      t.integer  "genre_id"
      t.string   "artist"
      t.string   "description"
      t.string   "song"
      t.integer  "user_id"
      t.text     "tone_data"
      t.integer  "product_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "genres", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
