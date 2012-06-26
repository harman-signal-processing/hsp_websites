class CreateRsoPages < ActiveRecord::Migration
  def self.up
    create_table :rso_pages do |t|
      t.string :name
      t.integer :brand_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :rso_pages
  end
end
