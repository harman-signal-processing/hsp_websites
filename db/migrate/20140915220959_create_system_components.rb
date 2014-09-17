class CreateSystemComponents < ActiveRecord::Migration
  def change
    create_table :system_components do |t|
      t.string :name
      t.integer :system_id
      t.integer :product_id
      t.text :description

      t.timestamps
    end
    add_index :system_components, :system_id
  end
end
