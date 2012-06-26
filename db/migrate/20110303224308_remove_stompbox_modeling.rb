class RemoveStompboxModeling < ActiveRecord::Migration
  def self.up
    drop_table :stompbox_models
    drop_table :product_stompbox_models
  end

  def self.down
    create_table :stompbox_models do |t|
      t.string :name
      t.text :description
      t.string :stompbox_image_file_name
      t.integer :stompbox_image_file_size
      t.string :stompbox_image_content_type
      t.datetime :stompbox_image_updated_at

      t.timestamps
    end
    create_table :product_stompbox_models do |t|
      t.integer :product_id
      t.integer :stompbox_model_id

      t.timestamps
    end
  end
end
