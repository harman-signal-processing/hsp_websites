class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :name
      t.integer :brand_id
      t.text :description

      t.timestamps
    end
    add_index :systems, :brand_id
  end
end
