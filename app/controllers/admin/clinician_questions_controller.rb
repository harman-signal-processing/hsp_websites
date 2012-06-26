class Admin::ClinicianQuestionsController < AdminController
  load_and_authorize_resource
  # GET /clinician_questions
  # GET /clinician_questions.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clinician_questions }
    end
  end

  # GET /clinician_questions/1
  # GET /clinician_questions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clinician_question }
    end
  end

  # GET /clinician_questions/new
  # GET /clinician_questions/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clinician_question }
    end
  end

  # GET /clinician_questions/1/edit
  def edit
  end

  # POST /clinician_questions
  # POST /clinician_questions.xml
  def create
    respond_to do |format|
      if @clinician_question.save
        format.html { redirect_to([:admin, @clinician_question], :notice => 'Clinician question was successfully created.') }
        format.xml  { render :xml => @clinician_question, :status => :created, :location => @clinician_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clinician_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clinician_questions/1
  # PUT /clinician_questions/1.xml
  def update
    respond_to do |format|
      if @clinician_question.update_attributes(params[:clinician_question])
        format.html { redirect_to([:admin, @clinician_question], :notice => 'Clinician question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clinician_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clinician_questions/1
  # DELETE /clinician_questions/1.xml
  def destroy
    @clinician_question.destroy
    respond_to do |format|
      format.html { redirect_to(admin_clinician_questions_url) }
      format.xml  { head :ok }
    end
  end

end
