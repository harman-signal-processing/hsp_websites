class Admin::TrainingClassesController < AdminController
  before_action :load_training_course
  before_action :initialize_training_class, only: :create
  load_and_authorize_resource

  # GET /admin/training_classes
  # GET /admin/training_classes.xml
  def index
    @training_classes = TrainingClass.where(training_course_id: website.brand.training_courses.pluck(:id))
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  {
        render xml: @training_classes
      }
    end
  end

  # GET /admin/training_classes/1
  # GET /admin/training_classes/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @training_class }
    end
  end

  # GET /admin/training_classes/new
  # GET /admin/training_classes/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @training_class }
    end
  end

  # GET /admin/training_classes/1/edit
  def edit
  end

  # POST /admin/training_classes
  # POST /admin/training_classes.xml
  def create
    @training_class.training_course = @training_course
    respond_to do |format|
      if @training_class.save
        format.html { redirect_to([:admin, @training_course], notice: 'Training class was successfully created.') }
        format.xml  { render xml: @training_class, status: :created, location: @training_class }
        website.add_log(user: current_user, action: "Created training class")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @training_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/training_classes/1
  # PUT /admin/training_classes/1.xml
  def update
    respond_to do |format|
      if @training_class.update(training_class_params)
        format.html { redirect_to([:admin, @training_course], notice: 'Training class was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated training class")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @training_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/training_classes/1
  # DELETE /admin/training_classes/1.xml
  def destroy
    @training_class.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @training_course]) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted training class")
  end

  private

  def initialize_training_class
    @training_class = TrainingClass.new(training_class_params)
  end

  def training_class_params
    params.require(:training_class).permit(
      :start_at,
      :end_at,
      :language,
      :instructor_id,
      :more_info_url,
      :location,
      :filled,
      :canceled,
      :training_course_id,
      :registration_url
    )
  end

  def load_training_course
    @training_course = TrainingCourse.find params[:training_course_id]
  end
end
