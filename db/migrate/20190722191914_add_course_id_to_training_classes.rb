class AddCourseIdToTrainingClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_classes, :training_course_id, :integer
    add_index :training_classes, :training_course_id
    remove_column :training_classes, :brand_id, :integer
    remove_column :training_classes, :name, :string
    remove_column :training_classes, :class_info_file_name, :string
    remove_column :training_classes, :class_info_file_size, :integer
    remove_column :training_classes, :class_info_content_type, :string
    remove_column :training_classes, :class_info_updated_at, :datetime
  end
end
