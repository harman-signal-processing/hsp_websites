class CreateWarrantyRegistrations < ActiveRecord::Migration
  def self.up
    create_table :warranty_registrations do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :middle_initial
      t.string :company
      t.string :jobtitle
      t.string :address1
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.string :fax
      t.string :email
      t.boolean :subscribe
      t.integer :brand_id
      t.integer :product_id
      t.string :serial_number
      t.date :registered_on
      t.date :purchased_on
      t.string :purchased_from
      t.string :purchase_country
      t.string :purchase_price
      t.string :age
      t.string :marketing_question1
      t.string :marketing_question2
      t.string :marketing_question3
      t.string :marketing_question4
      t.string :marketing_question5
      t.string :marketing_question6
      t.string :marketing_question7
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :warranty_registrations
  end
end
