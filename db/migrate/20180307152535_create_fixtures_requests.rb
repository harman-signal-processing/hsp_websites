class CreateFixturesRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :fixtures_requests do |t|
      t.string :name
      t.string :phone
      t.string :country
      t.string :email
      t.string :lighting_controller
      t.string :manufacturer
      t.string :fixture_name
      t.string :product_link
      t.string :required_modes
      t.text :notes
      t.date :required_on
      t.attachment :attachment

      t.timestamps
    end
  end
end
