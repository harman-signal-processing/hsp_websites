class CreateOnlineRetailerUsers < ActiveRecord::Migration
  def self.up
    create_table :online_retailer_users do |t|
      t.integer :online_retailer_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :online_retailer_users
  end
end
