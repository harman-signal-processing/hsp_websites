class AddMoreInfoUrlToTrainingCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_courses, :more_info_url, :string
  end
end
