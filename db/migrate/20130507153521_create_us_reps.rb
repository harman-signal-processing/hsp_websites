class CreateUsReps < ActiveRecord::Migration
  def change
    create_table :us_reps do |t|
      t.string :name
      t.string :contact
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :fax
      t.string :email
      t.string :cached_slug
      t.timestamps
    end
    add_index :us_reps, :cached_slug
  end
end
