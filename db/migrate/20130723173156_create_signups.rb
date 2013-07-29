class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.string :name
      t.string :email
      t.string :campaign
      t.integer :brand_id, :index => true
      t.timestamps
    end
  end
end
