class CreateToneUserRatings < ActiveRecord::Migration
  def self.up
    create_table :tone_user_ratings do |t|
      t.integer :tone_id
      t.integer :user_id
      t.float :user_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :tone_user_ratings
  end
end
