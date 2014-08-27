class CreateSystemOptions < ActiveRecord::Migration
  def change
    create_table :system_options do |t|
      t.integer :system_id
      t.string :name
      t.string :option_type
      t.integer :position
      t.integer :parent_id
      t.text :description

      t.timestamps
    end
    add_index :system_options, :system_id
    add_index :system_options, :parent_id
  end
end
