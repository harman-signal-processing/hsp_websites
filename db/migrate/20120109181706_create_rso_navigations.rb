class CreateRsoNavigations < ActiveRecord::Migration
  def self.up
    create_table :rso_navigations do |t|
      t.integer :brand_id
      t.integer :position
      t.string :name
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :rso_navigations
  end
end
