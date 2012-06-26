class CreateClinics < ActiveRecord::Migration
  def self.up
    create_table :clinics do |t|
      t.datetime :scheduled_at
      t.integer :clinician_id
      t.integer :dealer_id
      t.string :location
      t.float :travel_expenses
      t.float :food_expenses
      t.boolean :increased_sell_through
      t.boolean :generated_orders
      t.integer :brand_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clinics
  end
end
