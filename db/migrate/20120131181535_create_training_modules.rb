class CreateTrainingModules < ActiveRecord::Migration
  def self.up
    create_table :training_modules do |t|
      t.string :name
      t.integer :brand_id
      t.string :training_module_file_name
      t.string :training_module_content_type
      t.integer :training_module_file_size
      t.datetime :training_module_updated_at
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :training_modules
  end
end
