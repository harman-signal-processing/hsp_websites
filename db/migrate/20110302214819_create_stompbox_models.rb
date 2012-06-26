class CreateStompboxModels < ActiveRecord::Migration
  def self.up
    create_table :stompbox_models do |t|
      t.string :name
      t.text :description
      t.string :stompbox_image_file_name
      t.integer :stompbox_image_file_size
      t.string :stompbox_image_content_type
      t.datetime :stompbox_image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :stompbox_models
  end
end
