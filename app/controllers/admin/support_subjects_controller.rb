class Admin::SupportSubjectsController < AdminController
  before_action :initialize_support_subject, only: :create
  load_and_authorize_resource

  # GET /support_subjects
  # GET /support_subjects.xml
  def index
    @support_subjects = SupportSubject.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @support_subjects }
    end
  end

  # GET /support_subjects/1
  # GET /support_subjects/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @support_subject }
    end
  end

  # GET /support_subjects/new
  # GET /support_subjects/new.xml
  def new
    @support_subject.brand ||= website.brand
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @support_subject }
    end
  end

  # GET /support_subjects/1/edit
  def edit
  end

  # POST /support_subjects
  # POST /support_subjects.xml
  def create
    @support_subject.brand_id ||= website.brand_id
    respond_to do |format|
      if @support_subject.save
        format.html { redirect_to([:admin, @support_subject], notice: 'Support subject was successfully created.') }
        format.xml  { render xml: @support_subject, status: :created, location: @support_subject }
        website.add_log(user: current_user, action: "Created support subject: #{@support_subject.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @support_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /support_subjects/1
  # PUT /support_subjects/1.xml
  def update
    respond_to do |format|
      if @support_subject.update_attributes(support_subject_params)
        format.html { redirect_to([:admin, @support_subject], notice: 'Support subject was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated support subject: #{@support_subject.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @support_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /support_subjects/1
  # DELETE /support_subjects/1.xml
  def destroy
    @support_subject.destroy
    respond_to do |format|
      format.html { redirect_to(admin_support_subjects_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted support subject: #{@support_subject.name}")
  end

  private

  def initialize_support_subject
    @support_subject = SupportSubject.new(support_subject_params)
  end

  def support_subject_params
    params.require(:support_subject).permit!
  end
end
