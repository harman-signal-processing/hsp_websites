class CreateSystemOptionValues < ActiveRecord::Migration
  def change
    create_table :system_option_values do |t|
      t.integer :system_option_id
      t.string :name
      t.integer :position
      t.text :description
      t.boolean :default, default: false
      t.money :price

      t.timestamps
    end
    add_index :system_option_values, :system_option_id
  end
end
