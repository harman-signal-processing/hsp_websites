class CreateSoftwareTrainingModules < ActiveRecord::Migration
  def self.up
    create_table :software_training_modules do |t|
      t.integer :software_id
      t.integer :training_module_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :software_training_modules
  end
end
