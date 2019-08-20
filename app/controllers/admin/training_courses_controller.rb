class Admin::TrainingCoursesController < AdminController
  before_action :initialize_training_course, only: :create
  load_and_authorize_resource

  # GET /admin/training_courses
  # GET /admin/training_courses.xml
  def index
    @training_courses = @training_courses.where(brand_id: website.brand_id).order(Arel.sql("UPPER(name)"))
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  {
        @training_courses = TrainingCourse.all
        render xml: @training_courses
      }
    end
  end

  # GET /admin/training_courses/1
  # GET /admin/training_courses/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @training_course }
    end
  end

  # GET /admin/training_courses/new
  # GET /admin/training_courses/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @training_course }
    end
  end

  # GET /admin/training_courses/1/edit
  def edit
  end

  # POST /admin/training_courses
  # POST /admin/training_courses.xml
  def create
    @training_course.brand_id = website.brand_id
    respond_to do |format|
      if @training_course.save
        format.html { redirect_to([:admin, @training_course], notice: 'Training course was successfully created.') }
        format.xml  { render xml: @training_course, status: :created, location: @training_course }
        website.add_log(user: current_user, action: "Created training course")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @training_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/training_courses/1
  # PUT /admin/training_courses/1.xml
  def update
    respond_to do |format|
      if @training_course.update_attributes(training_course_params)
        format.html { redirect_to([:admin, @training_course], notice: 'Training course was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated training course")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @training_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/training_courses/1
  # DELETE /admin/training_courses/1.xml
  def destroy
    @training_course.destroy
    respond_to do |format|
      format.html { redirect_to(admin_training_courses_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted training class")
  end

  private

  def initialize_training_course
    @training_course = TrainingCourse.new(training_course_params)
  end

  def training_course_params
    params.require(:training_course).permit!
  end
end
