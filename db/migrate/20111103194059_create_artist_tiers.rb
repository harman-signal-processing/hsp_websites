class CreateArtistTiers < ActiveRecord::Migration
  def self.up
    create_table :artist_tiers do |t|
      t.string :name
      t.string :invitation_code

      t.timestamps
    end
  end

  def self.down
    drop_table :artist_tiers
  end
end
