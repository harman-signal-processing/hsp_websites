class CreateAmpModels < ActiveRecord::Migration
  def self.up
    create_table :amp_models do |t|
      t.string :name
      t.text :description
      t.string :amp_image_file_name
      t.integer :amp_image_file_size
      t.string :amp_image_content_type
      t.datetime :amp_image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :amp_models
  end
end
