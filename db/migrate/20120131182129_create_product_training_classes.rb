class CreateProductTrainingClasses < ActiveRecord::Migration
  def self.up
    create_table :product_training_classes do |t|
      t.integer :product_id
      t.integer :training_class_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_training_classes
  end
end
