class CreateSoftwareTrainingClasses < ActiveRecord::Migration
  def self.up
    create_table :software_training_classes do |t|
      t.integer :software_id
      t.integer :training_class_id

      t.timestamps
    end
  end

  def self.down
    drop_table :software_training_classes
  end
end
