class CreateProductAmpModels < ActiveRecord::Migration
  def self.up
    create_table :product_amp_models do |t|
      t.integer :product_id
      t.integer :amp_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_amp_models
  end
end
