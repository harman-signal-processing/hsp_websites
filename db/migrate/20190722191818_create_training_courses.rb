class CreateTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :training_courses do |t|
      t.string :name
      t.integer :brand_id
      t.text :description
      t.string :cached_slug
      t.string :send_registrations_to
      t.string :image_file_name
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :image_content_type
      t.text :short_description

      t.timestamps
    end
    add_index :training_courses, :cached_slug
    add_index :training_courses, :brand_id
  end
end
