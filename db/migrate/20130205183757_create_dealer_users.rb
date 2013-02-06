class CreateDealerUsers < ActiveRecord::Migration
  def change
    create_table :dealer_users do |t|
      t.integer :dealer_id
      t.integer :user_id

      t.timestamps
    end
    add_index :dealer_users, :dealer_id
    add_index :dealer_users, :user_id
  end
end
