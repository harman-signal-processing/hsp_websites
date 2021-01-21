class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.string :name
      t.string :street_1
      t.string :street_2
      t.string :street_3
      t.string :street_4
      t.string :locality
      t.string :region
      t.string :postal_code
      t.string :country

      t.timestamps
    end
    add_index :addresses, :addressable_id
  end
end
