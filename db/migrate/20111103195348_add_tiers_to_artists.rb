class AddTiersToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :invitation_code, :string
    add_column :artists, :artist_tier_id, :integer
    add_column :artists, :main_instrument, :string
    add_column :artists, :notable_career_moments, :text
  end

  def self.down
    remove_column :artists, :notable_career_moments
    remove_column :artists, :main_instrument
    remove_column :artists, :artist_tier_id
    remove_column :artists, :invitation_code
  end
end
