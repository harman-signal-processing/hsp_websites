class CreateProductStompboxModels < ActiveRecord::Migration
  def self.up
    create_table :product_stompbox_models do |t|
      t.integer :product_id
      t.integer :stompbox_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_stompbox_models
  end
end
