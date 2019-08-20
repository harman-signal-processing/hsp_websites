class TrainingClassRegistrationsController < ApplicationController
  before_action :load_course_and_class

  def new
    @training_class_registration = TrainingClassRegistration.new(training_class: @training_class)

    render_template
  end

  def create
    @training_class_registration = TrainingClassRegistration.new(training_class_registration_params)
    @training_class_registration.training_class = @training_class
    respond_to do |format|
      if @training_class_registration.save
        format.html { redirect_to @training_course, notice: "Your registration was received. Expect a response from us soon." }
      else
        format.html { render action: "new" }
      end
    end
  end

  private

  def load_course_and_class
    @training_course = TrainingCourse.find params[:training_course_id]
    @training_class = TrainingClass.find params[:training_class_id]
  end

  def training_class_registration_params
    params.require(:training_class_registration).permit(:name, :email, :comments)
  end

end
