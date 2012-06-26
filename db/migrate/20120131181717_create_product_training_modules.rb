class CreateProductTrainingModules < ActiveRecord::Migration
  def self.up
    create_table :product_training_modules do |t|
      t.integer :product_id
      t.integer :training_module_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :product_training_modules
  end
end
