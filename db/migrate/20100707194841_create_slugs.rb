class CreateSlugs < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :slugs, :options => options do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end
    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  end

  def self.down
    drop_table :slugs
  end
end
