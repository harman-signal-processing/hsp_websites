class CreateTrainingClasses < ActiveRecord::Migration
  def self.up
    create_table :training_classes do |t|
      t.string :name
      t.integer :brand_id
      t.datetime :start_at
      t.datetime :end_at
      t.string :language
      t.integer :instructor_id
      t.string :more_info_url
      t.integer :region_id
      t.string :location
      t.boolean :filled
      t.string :class_info_file_name
      t.integer :class_info_file_size
      t.string :class_info_content_type
      t.datetime :class_info_updated_at
      t.boolean :canceled

      t.timestamps
    end
  end

  def self.down
    drop_table :training_classes
  end
end
