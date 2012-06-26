class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end
    ["Blues", "Country", "Jazz", "Metal", "Other", "Rock", "Artists"].each do |n|
      Genre.create(:name => n)
    end
  end

  def self.down
    drop_table :genres
  end
end
