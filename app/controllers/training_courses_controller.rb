class TrainingCoursesController < ApplicationController

  def show
    @training_course = TrainingCourse.find(params[:id])
    render_template
  end

end
