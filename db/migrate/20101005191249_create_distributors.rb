class CreateDistributors < ActiveRecord::Migration
  def self.up
    create_table :distributors do |t|
      t.string :name
      t.text :detail
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :distributors
  end
end
