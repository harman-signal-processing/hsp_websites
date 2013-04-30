class CreateDistributorUsers < ActiveRecord::Migration
  def change
    create_table :distributor_users do |t|
      t.integer :distributor_id
      t.integer :user_id

      t.timestamps
    end
    add_index :distributor_users, :distributor_id
    add_index :distributor_users, :user_id
  end
end
