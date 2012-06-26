class CreateEffects < ActiveRecord::Migration
  def self.up
    create_table :effects do |t|
      t.string :name
      t.text :description
      t.string :effect_image_file_name
      t.integer :effect_image_file_size
      t.string :effect_image_content_type
      t.datetime :effect_image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :effects
  end
end
