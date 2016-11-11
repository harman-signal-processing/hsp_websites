class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :name
      t.string :cached_slug
      t.string :vertical_market_id

      t.timestamps null: false
    end
    add_index :solutions, :cached_slug, unique: true
  end
end
