class CreateTones < ActiveRecord::Migration
  def self.up
    create_table :tones do |t|
      t.string :name
      t.integer :genre_id
      t.string :artist
      t.string :description
      t.string :song
      t.integer :user_id
      t.text :tone_data
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tones
  end
end
